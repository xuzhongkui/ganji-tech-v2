#!/bin/bash
# 改进的模型健康检查脚本 - 支持OAuth测试

CONFIG_FILE="/root/.openclaw/openclaw.json"
HEALTH_FILE="/root/.openclaw/workspace/minimax-health.json"
LOG_FILE="/root/.openclaw/workspace/model-switcher.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 获取当前模型
get_current_model() {
    python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)
    print(config.get('agents', {}).get('defaults', {}).get('model', {}).get('primary', 'unknown'))
" 2>/dev/null
}

# 测试OAuth认证
test_oauth_availability() {
    log "测试MiniMax OAuth认证状态..."
    
    # 使用openclaw命令检查OAuth状态
    oauth_status=$(openclaw models status 2>&1 | grep -A5 "OAuth/token status" | grep "minimax-portal:default")
    
    if echo "$oauth_status" | grep -q "ok expires in"; then
        log "✅ OAuth认证正常: $oauth_status"
        return 0
    else
        log "❌ OAuth认证异常: $oauth_status"
        return 1
    fi
}

# 测试实际API调用（使用当前会话配置）
test_api_call() {
    log "测试实际API调用..."
    
    # 创建一个简单的测试消息
    test_response=$(openclaw agent --message "Hello, please respond with just 'OK'" --json 2>&1 | head -20)
    
    if echo "$test_response" | grep -q '"content"'; then
        log "✅ API调用成功"
        echo "响应示例: $(echo "$test_response" | grep -o '"content":"[^"]*"' | head -1 | cut -d'"' -f4)"
        return 0
    elif echo "$test_response" | grep -qi "error\|fail\|timeout"; then
        log "❌ API调用失败: $(echo "$test_response" | grep -i "error\|fail\|timeout" | head -1)"
        return 1
    else
        log "⚠️  API响应格式异常"
        return 2
    fi
}

# 主健康检查
health_check() {
    log "运行改进的健康检查..."
    
    current_model=$(get_current_model)
    log "当前模型: $current_model"
    
    status="unknown"
    note=""
    rate_limited=false
    
    if [[ "$current_model" == *"minimax"* ]]; then
        # 测试OAuth状态
        if test_oauth_availability; then
            # 测试实际API调用
            if test_api_call; then
                status="healthy"
                note="MiniMax OAuth认证正常，API调用成功"
            else
                status="api_error"
                note="OAuth认证正常但API调用失败"
            fi
        else
            status="oauth_error"
            note="MiniMax OAuth认证失败"
        fi
    else
        status="non_minimax"
        note="非MiniMax模型，跳过详细测试"
    fi
    
    # 更新健康文件
    cat > "$HEALTH_FILE" << EOF
{
  "last_check": "$(date -u +'%Y-%m-%dT%H:%M:%S.%3NZ')",
  "status": "$status",
  "rate_limited": $rate_limited,
  "current_model": "$current_model",
  "note": "$note",
  "recommendation": "$(get_recommendation "$status")"
}
EOF
    
    echo "=== 健康检查完成 ==="
    echo "当前模型: $current_model"
    echo "状态: $status"
    echo "备注: $note"
    echo "建议: $(get_recommendation "$status")"
}

# 获取建议
get_recommendation() {
    case "$1" in
        "healthy")
            echo "保持当前配置"
            ;;
        "oauth_error")
            echo "重新进行OAuth认证或切换到备用模型"
            ;;
        "api_error")
            echo "检查网络连接或模型可用性"
            ;;
        "rate_limited")
            echo "等待速率限制解除或切换到备用模型"
            ;;
        *)
            echo "检查配置并手动测试"
            ;;
    esac
}

# 运行健康检查
health_check