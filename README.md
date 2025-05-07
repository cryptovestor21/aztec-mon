### 📄 `README.md`

# Aztec Node Monitor

🛡️ Simple systemd-based monitoring script for an Aztec sequencer node. Sends Discord alerts when block production stalls.

---

## 🔧 Features

- Monitors `node_getL2Tips` via JSON-RPC
- Detects if the latest L2 block hasn't changed within 5 minutes
- Sends alerts to a Discord webhook
- Optional test mode to simulate alerting within seconds
- Runs as a systemd service

---

## 🚀 Quick Install (One-liner)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/cryptovestor21/aztec-mon/main/install.sh)"
````

This script will:

1. Ask for your Discord webhook URL.
2. Ask if you want to start in test mode.
3. Set up the monitor and start the systemd service.

---

## 🧪 Test Mode

If enabled during install:

* Sets alert threshold to **5 seconds**
* Sends a simulated block stall alert quickly
* Prefixes all messages with `[TEST ALERT]`

---

## 📁 Files Installed

* `/opt/aztec-monitor/aztec-monitor.sh` — main monitoring script
* `/opt/aztec-monitor/.env` — configuration file (webhook + test mode)
* `/etc/systemd/system/aztec-monitor.service` — systemd unit

---

## 🔁 Service Commands

Check service status:

```bash
sudo systemctl status aztec-monitor
```

Restart the monitor:

```bash
sudo systemctl restart aztec-monitor
```

View logs:

```bash
journalctl -u aztec-monitor -f
```

---

## ⚙️ Configuration

To update settings later, edit the `.env` file:

```bash
sudo nano /opt/aztec-monitor/.env
```

Update the values:

```env
DISCORD_WEBHOOK=https://discord.com/api/webhooks/...
TEST_ALERT=false
```

Then restart the service:

```bash
sudo systemctl restart aztec-monitor
```

---

## ✅ Example Discord Alerts

* ✅ `Aztec Monitor started on tst-azt-val0. Live alerting enabled.`
* 🚨 `Aztec Node block stuck at 28796 for 300 seconds!`

---

## 📄 License

MIT

