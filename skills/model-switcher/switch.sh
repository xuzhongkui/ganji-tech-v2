#!/bin/bash
# Model Switcher - Auto-switch between MiniMax and DeepSeek based on availability

CONFIG_FILE="/root/.openclaw/openclaw.json"
HEALTH_FILE="/root/.openclaw/workspace/minimax-health.json"
LOG_FILE="/root/.openclaw/workspace/model-switcher.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Get current model from config
get_current_model() {
    python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)
    print(config.get('agents', {}).get('defaults', {}).get('model', {}).get('primary', 'unknown'))
" 2>/dev/null
}

# Check if model is rate limited
check_model_status() {
    local model_url="$1"
    local api_key="$2"
    
    response=$(curl -s -w "\n%{http_code}" -X POST "$model_url" \
        -H "Authorization: Bearer $api_key" \
        -H "Content-Type: application/json" \
        -d '{"model":"MiniMax-M2.5","max_tokens":10,"messages":[{"role":"user","content":"hi"}]}' 2>/dev/null)
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [[ "$http_code" == "429" ]] || echo "$body" | grep -qi "rate.limit\|quota"; then
        echo "rate_limited"
    elif [[ "$http_code" == "200" ]] && echo "$body" | grep -q "content\|message"; then
        echo "ok"
    else
        echo "error: $body"
    fi
}

# Switch to specified model
switch_model() {
    local new_model="$1"
    
    python3 -c "
import json

with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)

# Update primary model
if 'agents' not in config:
    config['agents'] = {}
if 'defaults' not in config['agents']:
    config['agents']['defaults'] = {}
if 'model' not in config['agents']['defaults']:
    config['agents']['defaults']['model'] = {}

config['agents']['defaults']['model']['primary'] = '$new_model'

with open('$CONFIG_FILE', 'w') as f:
    json.dump(config, f, indent=2)

print('Switched to: $new_model')
"
    
    log "Model switched to: $new_model"
}

# Main health check function
health_check() {
    log "Running health check..."
    
    # Read MiniMax API key from environment or config
    minimax_key="${MINIMAX_API_KEY:-}"
    
    if [[ -z "$minimax_key" ]]; then
        log "MiniMax API key not found in environment"
        return 1
    fi
    
    # Check MiniMax status
    status=$(check_model_status "https://api.minimaxi.com/anthropic/v1/messages" "$minimax_key")
    
    current_model=$(get_current_model)
    log "Current model: $current_model, MiniMax status: $status"
    
    # Update health file
    python3 -c "
import json
from datetime import datetime

health = {
    'last_check': datetime.utcnow().isoformat() + 'Z',
    'status': '$status',
    'rate_limited': '$status' == 'rate_limited',
    'current_model': '$current_model'
}

with open('$HEALTH_FILE', 'w') as f:
    json.dump(health, f, indent=2)
"
    
    # Auto-switch logic
    if [[ "$status" == "rate_limited" ]] && [[ "$current_model" == *"minimax"* ]]; then
        log "MINIMAX rate limited! Switching to DeepSeek..."
        switch_model "deepseek/deepseek-chat"
        echo "⚠️ MiniMax 被限流了，已自动切换到 DeepSeek"
    elif [[ "$status" == "ok" ]] && [[ "$current_model" == *"deepseek"* ]]; then
        log "MINIMAX recovered! Suggesting switch back..."
        switch_model "minimax-portal/MiniMax-M2.5"
        echo "✅ MiniMax 已恢复！已切换回 MiniMax"
    fi
}

# Run health check
health_check
