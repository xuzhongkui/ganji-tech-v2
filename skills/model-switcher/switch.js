#!/usr/bin/env node
/**
 * Model Switcher - Auto-switch between MiniMax and DeepSeek
 * 
 * Usage: node switch.js [--check-only]
 * 
 * --check-only: Only check status, don't switch models
 */

const fs = require('fs');
const path = require('path');

const CONFIG_FILE = process.env.OPENCLAW_CONFIG || '/root/.openclaw/openclaw.json';
const HEALTH_FILE = '/root/.openclaw/workspace/minimax-health.json';

const MODELS = {
  minimax: 'minimax-portal/MiniMax-M2.5',
  deepseek: 'deepseek/deepseek-chat'
};

function log(msg) {
  console.log(`[${new Date().toISOString()}] ${msg}`);
}

async function checkMiniMaxStatus() {
  const { spawn } = require('child_process');
  
  return new Promise((resolve) => {
    const apiKey = process.env.MINIMAX_API_KEY;
    
    if (!apiKey) {
      log('ERROR: MINIMAX_API_KEY not found');
      resolve({ status: 'error', message: 'No API key' });
      return;
    }
    
    const curl = spawn('curl', [
      '-s', '-w', '\\n%{http_code}',
      '-X', 'POST',
      'https://api.minimaxi.com/anthropic/v1/messages',
      '-H', `Authorization: Bearer ${apiKey}`,
      '-H', 'Content-Type: application/json',
      '-d', JSON.stringify({
        model: 'MiniMax-M2.5',
        max_tokens: 10,
        messages: [{ role: 'user', content: 'hi' }]
      })
    ]);
    
    let output = '';
    let errorOutput = '';
    
    curl.stdout.on('data', (data) => { output += data; });
    curl.stderr.on('data', (data) => { errorOutput += data; });
    
    curl.on('close', (code) => {
      const lines = output.trim().split('\n');
      const httpCode = lines.pop();
      const body = lines.join('\n');
      
      // Handle different response conditions
    const bodyLower = body.toLowerCase();
    
    if (httpCode === '429' || bodyLower.includes('rate_limit') || bodyLower.includes('quota')) {
      resolve({ status: 'rate_limited', httpCode, body });
    } else if (httpCode === '200' && (bodyLower.includes('content') || bodyLower.includes('message'))) {
      resolve({ status: 'ok', httpCode, body });
    } else if (bodyLower.includes('authentication_error') || bodyLower.includes('login fail') || bodyLower.includes('invalid')) {
      // Auth error - treat as unavailable but don't auto-switch
      resolve({ status: 'auth_error', httpCode, body: body.substring(0, 200) });
    } else if (httpCode && parseInt(httpCode) >= 400) {
      resolve({ status: 'error', httpCode, body: body.substring(0, 200) });
    } else {
      // Default to ok if we get any valid response
      resolve({ status: 'ok', httpCode, body });
    }
    });
    
    curl.on('error', (err) => {
      resolve({ status: 'error', message: err.message });
    });
  });
}

function getCurrentModel() {
  try {
    const config = JSON.parse(fs.readFileSync(CONFIG_FILE, 'utf8'));
    return config.agents?.defaults?.model?.primary || 'unknown';
  } catch (e) {
    log(`Error reading config: ${e.message}`);
    return 'unknown';
  }
}

function switchModel(newModel) {
  try {
    const config = JSON.parse(fs.readFileSync(CONFIG_FILE, 'utf8'));
    
    if (!config.agents) config.agents = {};
    if (!config.agents.defaults) config.agents.defaults = {};
    if (!config.agents.defaults.model) config.agents.defaults.model = {};
    
    config.agents.defaults.model.primary = newModel;
    
    fs.writeFileSync(CONFIG_FILE, JSON.stringify(config, null, 2));
    log(`Model switched to: ${newModel}`);
    return true;
  } catch (e) {
    log(`Error switching model: ${e.message}`);
    return false;
  }
}

function updateHealthFile(status, currentModel) {
  const health = {
    last_check: new Date().toISOString(),
    status: status.status,
    rate_limited: status.status === 'rate_limited',
    current_model: currentModel
  };
  
  fs.writeFileSync(HEALTH_FILE, JSON.stringify(health, null, 2));
  return health;
}

async function main() {
  const checkOnly = process.argv.includes('--check-only');
  
  log('Running model health check...');
  
  const currentModel = getCurrentModel();
  log(`Current model: ${currentModel}`);
  
  const status = await checkMiniMaxStatus();
  log(`MiniMax status: ${status.status}`);
  
  const health = updateHealthFile(status, currentModel);
  
  // Auto-switch logic - silent, no notifications
  if (status.status === 'rate_limited' && currentModel.includes('minimax')) {
    log('MINIMAX rate limited - auto-switching to DeepSeek');
    switchModel(MODELS.deepseek);
  } else if (status.status === 'ok' && currentModel.includes('deepseek')) {
    log('MINIMAX recovered - auto-switching back');
    switchModel(MODELS.minimax);
  }
  
  // Always log status
  log(`Status: ${status.status}, Model: ${currentModel}`);
}

main().catch(console.error);
