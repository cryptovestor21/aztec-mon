#!/bin/bash

set -e

echo "🔧 Installing Aztec Monitor..."

# Clone repo if run from GitHub one-liner (optional safeguard)
if [ ! -f aztec-monitor.sh ]; then
  echo "❌ Please run this inside the cloned aztec-mon repo."
  exit 1
fi

# Ask for Discord webhook
read -rp "🔗 Enter your Discord webhook URL: " webhook
if [[ -z "$webhook" ]]; then
  echo "❌ Webhook URL is required. Exiting."
  exit 1
fi

# Ask if test mode should be enabled
read -rp "🧪 Enable test mode? (y/n): " test_mode
test_mode_value=false
if [[ "$test_mode" == [Yy]* ]]; then
  test_mode_value=true
fi

# Install to /opt
sudo mkdir -p /opt/aztec-monitor
sudo cp aztec-monitor.sh aztec-monitor.service /opt/aztec-monitor/
sudo chmod +x /opt/aztec-monitor/aztec-monitor.sh

# Write .env
cat <<EOF | sudo tee /opt/aztec-monitor/.env > /dev/null
DISCORD_WEBHOOK=$webhook
TEST_ALERT=$test_mode_value
EOF

# Move systemd unit and start service
sudo cp aztec-monitor.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable aztec-monitor
sudo systemctl restart aztec-monitor

echo "✅ Aztec Monitor installed and running."
echo "📡 Discord alerts will go to: $webhook"
echo "📁 Config: /opt/aztec-monitor/.env"
