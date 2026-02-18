#!/bin/bash
# Simple model health check script

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

# Test model availability with actual API call
test_model_availability() {
    local model="$1"
    log "Checking model configuration: $model"
    
    if [[ "$model" == *"minimax"* ]]; then
        # Check if we have the minimax-portal-auth plugin enabled
        if grep -q "minimax-portal-auth" /root/.openclaw/openclaw.json; then
            log "MiniMax plugin is configured"
            
            # Try to get OAuth token
            local token_file="$HOME/.openclaw/agents/main/agent/auth-profiles.json"
            if [[ -f "$token_file" ]]; then
                local token=$(jq -r '.profiles."minimax-portal:default".access' "$token_file" 2>/dev/null)
                if [[ -n "$token" && "$token" != "null" ]]; then
                    log "Found OAuth token, testing API connection..."
                    
                    # Test API with a simple request
                    local response=$(curl -s -X POST "https://api.minimax.chat/v1/chat/completions" \
                        -H "Content-Type: application/json" \
                        -H "Authorization: Bearer $token" \
                        -d '{
                            "model": "MiniMax-M2.5",
                            "messages": [{"role": "user", "content": "Hello"}],
                            "max_tokens": 5
                        }' 2>/dev/null)
                    
                    if echo "$response" | grep -q '"choices"' || echo "$response" | grep -q '"id"'; then
                        log "MiniMax API test successful"
                        return 0
                    elif echo "$response" | grep -q '"type":"error"'; then
                        local error_msg=$(echo "$response" | jq -r '.error.message // "unknown error"' 2>/dev/null)
                        log "MiniMax API error: $error_msg"
                        return 1
                    else
                        log "MiniMax API returned unexpected response: $response"
                        return 1
                    fi
                else
                    log "No valid OAuth token found"
                    return 1
                fi
            else
                log "Token file not found: $token_file"
                return 1
            fi
        else
            log "MiniMax plugin not found in config"
            return 1
        fi
    else
        log "Non-MiniMax model, skipping detailed check"
        return 0
    fi
}

# Simple test: check if we can get the current model
health_check() {
    log "Running comprehensive health check..."
    
    current_model=$(get_current_model)
    log "Current model: $current_model"
    
    # Test the current model
    if [[ "$current_model" == *"minimax"* ]]; then
        log "Testing MiniMax model availability..."
        
        # Direct API test with OAuth token
        local token_file="/root/.openclaw/agents/main/agent/auth-profiles.json"
        if [[ -f "$token_file" ]]; then
            local token=$(jq -r '.profiles."minimax-portal:default".access' "$token_file" 2>/dev/null)
            if [[ -n "$token" && "$token" != "null" ]]; then
                log "Found OAuth token, testing API connection..."
                
                local response=$(curl -s -X POST "https://api.minimax.chat/v1/chat/completions" \
                    -H "Content-Type: application/json" \
                    -H "Authorization: Bearer $token" \
                    -d '{
                        "model": "MiniMax-M2.5",
                        "messages": [{"role": "user", "content": "Hello"}],
                        "max_tokens": 5
                    }' 2>/dev/null)
                
                if echo "$response" | grep -q '"choices"' || echo "$response" | grep -q '"id"'; then
                    log "MiniMax API test successful"
                    status="healthy"
                    note="MiniMax model is working correctly (OAuth token valid)"
                elif echo "$response" | grep -q '"type":"error"'; then
                    local error_msg=$(echo "$response" | jq -r '.error.message // "unknown error"' 2>/dev/null)
                    log "MiniMax API error: $error_msg"
                    status="unavailable"
                    note="MiniMax API error: $error_msg"
                else
                    log "MiniMax API returned unexpected response"
                    status="unavailable"
                    note="MiniMax API returned unexpected response"
                fi
            else
                log "No valid OAuth token found"
                status="unavailable"
                note="No valid OAuth token found"
            fi
        else
            log "Token file not found"
            status="unavailable"
            note="Token file not found"
        fi
    else
        status="unknown"
        note="Non-MiniMax model detected, skipping specific test"
    fi
    
    # Update health file
    cat > "$HEALTH_FILE" << EOF
{
  "last_check": "$(date -u +'%Y-%m-%dT%H:%M:%S.%3NZ')",
  "status": "$status",
  "rate_limited": false,
  "current_model": "$current_model",
  "note": "$note"
}
EOF
    
    echo "健康检查完成。当前模型: $current_model"
    echo "状态: $status"
    echo "备注: $note"
}

# Run health check
health_check