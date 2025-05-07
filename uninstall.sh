#!/bin/bash

echo "⚠️  This will stop and remove the Aztec monitor service and all related files."

read -rp "Are you sure you want to proceed? (y/n): " confirm
if [[ "$confirm" != [Yy]* ]]; then
  echo "❌ Uninstall cancelled."
  exit 1
fi

echo "🛑 Stopping service..."
sudo systemctl stop aztec-monitor 2>/dev/null || true

echo "🧼 Disabling service..."
sudo systemctl disable aztec-monitor 2>/dev/null || true

echo "🗑️  Removing systemd unit..."
sudo rm -f /etc/systemd/system/aztec-monitor.service

echo "🧹 Cleaning up files..."
sudo rm -rf /opt/aztec-monitor

echo "🔄 Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "✅ Aztec Monitor successfully uninstalled."
