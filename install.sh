#!/bin/bash

set -e

echo "🔧 Installing Aztec Monitor..."

# Clone into /opt if not already present
if [ ! -d /opt/aztec-monitor ]; then
  git clone https://https://github.com/cryptovestor21/aztec-monitor.git /opt/aztec-monitor
fi

cd /opt/aztec-monitor
chmod +x aztec-monitor.sh

# Create a sample .env if not present
if [ ! -f .env ]; then
  cat <<EOF > .env
DISCORD_WEBHOOK=https://discord.com/api/webhooks/your_webhook_url_here
TEST_ALERT=false
EOF
  echo "📄 Created /opt/aztec-monitor/.env — please edit this file with your Discord webhook."
fi

# Install systemd service
cp aztec-monitor.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable aztec-monitor
systemctl restart aztec-monitor

echo "✅ Aztec Monitor is installed and running."
