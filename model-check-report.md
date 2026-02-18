# 模型健康检查报告
**时间**: 2026-02-17 07:17:09 UTC
**检查类型**: 自动模型切换检查

## 当前状态

### 1. 当前模型
- **模型**: `minimax-portal/MiniMax-M2.5`
- **认证方式**: OAuth
- **状态**: ❌ 认证失败

### 2. 检查结果
- ✅ 健康检查脚本执行成功
- ❌ MiniMax API 认证失败 (401 错误)
- ✅ 环境变量 `MINIMAX_API_KEY` 存在
- ✅ 备用模型 `deepseek/deepseek-chat` 可用

### 3. 错误详情
```
错误类型: authorized_error
错误信息: login fail: Please carry the API secret key in the 'Authorization' field of the request header (1004)
请求ID: 05e348fce5ddcc10613abd8b66beb6db
```

### 4. 配置信息
- **主模型**: `minimax-portal/MiniMax-M2.5`
- **备用模型**: `deepseek/deepseek-chat`
- **其他可用模型**: 
  - `minimax-portal/MiniMax-M2.1`
  - `deepseek/deepseek-reasoner`

## 建议操作

### 立即操作
1. **切换到备用模型**: 建议立即切换到 `deepseek/deepseek-chat`
2. **检查 OAuth 状态**: 需要手动检查 MiniMax OAuth 认证状态

### 长期解决方案
1. **刷新 OAuth 令牌**: 可能需要重新授权 MiniMax
2. **验证 API 密钥**: 确认 API 密钥是否有效
3. **考虑备用提供商**: 如果 MiniMax 持续不可用，考虑配置其他模型提供商

## 系统信息
- **OpenClaw 版本**: 2026.2.15
- **当前会话**: cron:25802c1f-1379-4393-a39e-b0945904b821
- **执行模型**: `deepseek/deepseek-chat`

---
*报告生成时间: 2026-02-17T07:17:09Z*