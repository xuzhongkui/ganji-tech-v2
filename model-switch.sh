#!/bin/bash

echo "=== 模型自动切换检查 ==="
echo "时间: $(date)"
echo ""

# 检查 MiniMax 健康状态
if [ -f "/root/.openclaw/workspace/minimax-health.json" ]; then
    STATUS=$(jq -r '.status' /root/.openclaw/workspace/minimax-health.json 2>/dev/null || echo "unknown")
    echo "MiniMax 状态: $STATUS"
    
    if [ "$STATUS" = "healthy" ]; then
        echo "✅ MiniMax 可用，保持当前模型"
        CURRENT_MODEL="minimax-portal/MiniMax-M2.5"
    else
        echo "⚠️  MiniMax 不可用，切换到 DeepSeek"
        CURRENT_MODEL="deepseek/deepseek-chat"
        
        # 更新 OpenClaw 配置以使用 DeepSeek 作为默认模型
        openclaw config set agents.defaults.model.primary deepseek/deepseek-chat
        openclaw config set agents.defaults.model.fallbacks '[]'
        
        echo "已切换到 DeepSeek 作为默认模型"
    fi
else
    echo "❓ MiniMax 健康状态文件不存在"
    echo "⚠️  切换到 DeepSeek 作为安全备选"
    CURRENT_MODEL="deepseek/deepseek-chat"
fi

echo ""
echo "当前有效模型: $CURRENT_MODEL"
echo "=== 检查完成 ==="