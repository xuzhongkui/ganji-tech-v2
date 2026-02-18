# 模型自动切换检查报告

## 执行时间
2026-02-17 12:17:09 UTC

## 检查结果

### 1. MiniMax 模型状态
- **状态**: ❌ 不可用 (unhealthy)
- **当前模型**: minimax-portal/MiniMax-M2.5
- **错误信息**: "login fail: Please carry the API secret key in the 'Authorization' field of the request header (1004)"
- **原因**: API密钥无效或过期

### 2. DeepSeek 模型状态
- **状态**: ✅ 可用 (healthy)
- **测试响应**: 成功获取到 "Hello! 👋 It's great to meet you"
- **API密钥**: 有效

### 3. 自动切换操作
1. 检测到 MiniMax 认证失败
2. 自动切换到 DeepSeek 作为主要模型
3. 更新 OpenClaw 配置:
   - 主要模型: `deepseek/deepseek-chat`
   - 备选模型: 空数组
4. 发送 SIGUSR1 信号重新加载网关配置

### 4. 当前配置状态
- **主要模型**: `deepseek/deepseek-chat`
- **备选模型**: 无
- **配置已生效**: 是

## 建议操作

### 立即操作
1. ✅ 已完成: 切换到 DeepSeek 模型
2. ✅ 已完成: 更新系统配置

### 后续操作
1. **修复 MiniMax API 密钥**:
   - 获取新的有效 MiniMax API 密钥
   - 更新环境变量 `MINIMAX_API_KEY`
   - 重新测试 MiniMax 连接

2. **恢复双模型配置**:
   - 当 MiniMax 修复后，重新配置为:
     - 主要模型: `minimax-portal/MiniMax-M2.5`
     - 备选模型: `deepseek/deepseek-chat`

3. **监控设置**:
   - 定期运行健康检查脚本
   - 设置自动切换机制

## 脚本文件
- **健康检查**: `/root/.openclaw/workspace/model-health-check.sh`
- **模型切换**: `/root/.openclaw/workspace/model-switch.sh`
- **状态文件**: `/root/.openclaw/workspace/minimax-health.json`
- **测试脚本**: `/root/.openclaw/workspace/test-minimax-api.sh`

## 下次检查建议
建议设置定时任务，每30分钟检查一次模型健康状况，并在检测到问题时自动切换。