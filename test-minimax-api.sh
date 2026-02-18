#!/bin/bash

echo "=== MiniMax API 详细测试 ==="
echo "时间: $(date)"
echo ""

# 检查环境变量
echo "1. 检查环境变量:"
if [ -n "$MINIMAX_API_KEY" ]; then
    echo "   MINIMAX_API_KEY: 已设置 (长度: $(echo -n "$MINIMAX_API_KEY" | wc -c) 字符)"
    echo "   前10个字符: ${MINIMAX_API_KEY:0:10}..."
else
    echo "   MINIMAX_API_KEY: 未设置"
    exit 1
fi

echo ""
echo "2. 测试 API 调用:"

# 测试 API 调用
RESPONSE=$(curl -s -X POST "https://api.minimax.chat/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $MINIMAX_API_KEY" \
  -d '{
    "model": "MiniMax-M2.5",
    "messages": [{"role": "user", "content": "Hello, please respond with just OK if you can read this."}],
    "stream": false,
    "max_tokens": 10
  }' 2>&1)

echo "响应:"
echo "$RESPONSE" | head -100

echo ""
echo "3. 分析响应:"

if echo "$RESPONSE" | grep -q "authorized_error"; then
    echo "   ❌ 认证错误: API密钥无效或过期"
    echo "   错误信息: $(echo "$RESPONSE" | grep -o '"message":"[^"]*"' | cut -d'"' -f4)"
elif echo "$RESPONSE" | grep -q "rate_limit"; then
    echo "   ⚠️  速率限制: API调用受限"
elif echo "$RESPONSE" | grep -q '"choices"'; then
    echo "   ✅ API调用成功"
    echo "   响应内容: $(echo "$RESPONSE" | grep -o '"content":"[^"]*"' | cut -d'"' -f4)"
else
    echo "   ❓ 未知响应格式"
    echo "   原始响应开头: $(echo "$RESPONSE" | head -20)"
fi

echo ""
echo "=== 测试完成 ==="