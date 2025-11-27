#!/bin/bash

# Check if nordvpn is installed
if ! command -v nordvpn &> /dev/null; then
  echo '{"text": "", "tooltip": "NordVPN not installed"}'
  exit 0
fi

# Get NordVPN status
status=$(nordvpn status 2>/dev/null)

if echo "$status" | grep -q "Status: Connected"; then
  # Extract country name
  country=$(echo "$status" | grep "Country:" | awk '{print $2}')
  city=$(echo "$status" | grep "City:" | awk '{print $2}')

  if [ -n "$country" ]; then
    echo "{\"text\": \"󰖂 $country\", \"tooltip\": \"Connected to $city, $country\", \"class\": \"connected\"}"
  else
    echo '{"text": "󰖂", "tooltip": "Connected", "class": "connected"}'
  fi
else
  echo '{"text": "󰖂", "tooltip": "Disconnected", "class": "disconnected"}'
fi
