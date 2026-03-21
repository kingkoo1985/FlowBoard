#!/usr/bin/env node

/**
 * 测试 FlowBoard → Feishu Webhook
 */

const GATEWAY_URL = 'http://127.0.0.1:15988';
const HOOKS_TOKEN = 'a3f5b8c7e2d9f4a0';
const DELIVER_CHANNEL = 'feishu';
const DELIVER_TO = 'ou_b5b40e4f5b0e36a124fff581dc6c27d8';

async function testWebhook() {
  console.log('🧪 测试 FlowBoard → Feishu Webhook');
  console.log('Gateway URL:', GATEWAY_URL);
  console.log('Channel:', DELIVER_CHANNEL);
  console.log('To:', DELIVER_TO);
  console.log('');

  const payload = {
    message: '🧪 FlowBoard → Feishu 测试消息！\n\n时间: ' + new Date().toLocaleString('zh-CN'),
    name: 'Canvas Promote',
    deliver: true,
    channel: DELIVER_CHANNEL,
    wakeMode: 'now',
    to: DELIVER_TO
  };

  console.log('📤 发送 payload:');
  console.log(JSON.stringify(payload, null, 2));

  try {
    const response = await fetch(`${GATEWAY_URL}/hooks/agent`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${HOOKS_TOKEN}`,
      },
      body: JSON.stringify(payload),
    });

    console.log('');
    console.log('📥 响应状态:', response.status);
    console.log('响应 Headers:', Object.fromEntries(response.headers.entries()));

    const responseText = await response.text();
    console.log('');
    console.log('响应内容:');
    console.log(responseText);

    if (response.ok) {
      console.log('');
      console.log('✅ Webhook 调用成功！');
    } else {
      console.log('');
      console.log('❌ Webhook 调用失败');
    }
  } catch (error) {
    console.error('');
    console.error('❌ 请求错误:', error.message);
  }
}

testWebhook();
