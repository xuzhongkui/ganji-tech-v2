#!/bin/bash

echo "=== 模型切换测试 ==="
echo "当前时间: $(date)"
echo ""

# 检查当前会话状态
echo "1. 检查当前会话状态:"
session_status_output=$(openclaw session status 2>&1)
echo "$session_status_output"
echo ""

# 检查健康状态文件
echo "2. 检查健康状态文件:"
if [ -f "/root/.openclaw/workspace/minimax-health.json" ]; then
    cat "/root/.openclaw/workspace/minimax-health.json"
else
    echo "健康状态文件不存在"
fi
echo ""

# 测试MiniMax API
echo "3. 测试MiniMax API连接:"
echo "尝试使用OAuth认证测试MiniMax API..."
# 这里应该测试实际的API连接

# 检查是否有备用模型可用
echo "4. 检查备用模型配置:"
echo "主模型: minimax-portal/MiniMax-M2.5"
echo "备用模型: deepseek/deepseek-chat"
echo ""

# 模拟模型切换逻辑
echo "5. 模拟模型切换逻辑:"
current_model="minimax-portal/MiniMax-M2.5"
backup_model="deepseek/deepseek-chat"

# 这里应该添加实际的健康检查逻辑
# 如果MiniMax不可用，则切换到DeepSeek

echo "当前模型: $current_model"
echo "备用模型: $backup_model"
echo ""

echo "=== 测试完成 ==="