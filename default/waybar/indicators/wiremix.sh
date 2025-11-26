#!/bin/bash

if pgrep -x "wiremix" >/dev/null; then
  echo '{"text": "", "tooltip": "Wiremix (click to focus)", "class": "active"}'
else
  echo '{"text": "", "tooltip": "Click to open Wiremix"}'
fi
