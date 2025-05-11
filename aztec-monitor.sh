#!/bin/bash

HOST="http://localhost:8080"
CHECK_INTERVAL=60         # Default: check every 60 seconds
STALE_THRESHOLD=300       # Default: alert if block hasn't moved in 5 minutes

DISCORD_WEBHOOK="${DISCORD_WEBHOOK:-}"
TEST_ALERT="${TEST_ALERT:-false}"
HOSTNAME=$(hostname)

last_block_number=""
last_update_time=$(date +%s)

send_discord_alert() {
  local message="$1"
  if [[ -n "$DISCORD_WEBHOOK" ]]; then
    curl -s -H "Content-Type: application/json" -X POST \
      -d "{\"content\": \"$message\"}" \
      "$DISCORD_WEBHOOK" > /dev/null
  fi
}

get_current_block_number() {
  curl -s -X POST -H 'Content-Type: application/json' \
    -d '{"jsonrpc":"2.0","method":"node_getL2Tips","params":[],"id":1}' \
    "$HOST" | jq -r '.result.latest.number'
}

# Handle test mode configuration
if [[ "$TEST_ALERT" == "true" ]]; then
  CHECK_INTERVAL=5
  STALE_THRESHOLD=5
  test_block=$(get_current_block_number)
  if [[ -n "$test_block" && "$test_block" != "null" ]]; then
    send_discord_alert "✅ [TEST MODE] Aztec Monitor started on \`$HOSTNAME\`. Latest block: $test_block. Simulated alert in 5 seconds if no change."
    echo "$(date) - Test alert setup complete (block $test_block)"
  else
    echo "$(date) - Test alert skipped: could not retrieve block number."
  fi
else
  live_block=$(get_current_block_number)
  if [[ -n "$live_block" && "$live_block" != "null" ]]; then
    send_discord_alert "✅ Aztec Monitor started on \`$HOSTNAME\`. Live alerting enabled. Latest block: $live_block"
    echo "$(date) - Live alert startup sent (block $live_block)"
  else
    echo "$(date) - Live alert skipped: could not retrieve block number."
  fi
fi

# Main monitoring loop
while true; do
  block_number=$(get_current_block_number)

  if [[ -z "$block_number" || "$block_number" == "null" ]]; then
    echo "$(date) - Failed to retrieve block number."
  else
    echo "$(date) - Latest block number: $block_number"

    if [[ "$block_number" != "$last_block_number" ]]; then
      last_block_number="$block_number"
      last_update_time=$(date +%s)
    else
      now=$(date +%s)
      elapsed=$((now - last_update_time))

      if (( elapsed >= STALE_THRESHOLD )); then
        if [[ "$TEST_ALERT" == "true" ]]; then
          msg="🚨 [TEST ALERT] Aztec Node block stuck at $block_number for $((elapsed)) seconds! Host: \`$HOSTNAME\`"
        else
          msg="🚨 Aztec Node block stuck at $block_number for $((elapsed)) seconds! Host: \`$HOSTNAME\`"
        fi

        echo "$(date) - $msg"
        send_discord_alert "$msg"
        sleep $STALE_THRESHOLD  # avoid repeated alerts
      fi
    fi
  fi

  sleep "$CHECK_INTERVAL"
done
