---
name: ModelSwitcher
description: Auto-switch between MiniMax and DeepSeek based on availability. Monitors rate limits and seamlessly switches models.
---

## Overview

This skill automatically switches between MiniMax and DeepSeek models based on availability. It monitors rate limits and ensures uninterrupted service.

## Usage

The skill provides two modes:

### Mode 1: Auto-Switch (Recommended)

Before each important request, call `ensure_model_available` to check and switch models:

```
Call ensure_model_available with:
- preferred_model: "minimax-portal/MiniMax-M2.5"
- fallback_model: "deepseek/deepseek-chat"
```

This will:
1. Test MiniMax availability
2. If rate limited, auto-switch to DeepSeek
3. Return the available model to use

### Mode 2: Proactive Monitoring

Set up a cron job to periodically check and switch:

```json
{
  "schedule": { "kind": "every", "everyMs": 300000 },
  "payload": { "kind": "agentTurn", "message": "Call ensure_model_available with preferred_model=minimax-portal/MiniMax-M2.5 and fallback_model=deepseek/deepseek-chat" }
}
```

## Functions

### ensure_model_available

Checks if preferred model is available, switches to fallback if not.

Parameters:
- `preferred_model`: Model to try first (default: minimax-portal/MiniMax-M2.5)
- `fallback_model`: Model to switch to if unavailable (default: deepseek/deepseek-chat)

## How It Works

1. **Check**: Test API with a minimal request
2. **Detect**: Identify rate limit (429) or quota errors
3. **Switch**: Update config to use available model
4. **Notify**: Alert user of the switch
5. **Restore**: When preferred model recovers, suggest switching back

## Setup

No additional setup required. The skill reads API keys from environment.

## Example Workflow

```
User:帮我写个函数
→ Skill checks MiniMax status
→ MiniMax OK → Uses MiniMax
→ MiniMax rate limited → Switches to DeepSeek automatically
→ User gets response from DeepSeek

[5 minutes later]
→ Health check detects MiniMax recovered
→ Sends notification: "MiniMax 恢复了！用 /mini 切换回来"
```
