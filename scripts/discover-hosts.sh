#!/bin/bash

# this script is copied and run on the prometheus server to automatically detect webservers that are
# exporting metrics. 
OUT=/etc/prometheus/targets

mkdir -p "$OUT"

# node-exporter
nmap -p 9100 --open -oG - 192.168.100.0/24 \
  | awk '/9100\/open/ {print $2}' \
  | jq -R '{targets:[. + ":9100"], labels:{job:"node"}}' \
  | jq -s . > "$OUT/node.json"

# nginx-exporter
nmap -p 9113 --open -oG - 192.168.100.0/24 \
  | awk '/9113\/open/ {print $2}' \
  | jq -R '{targets:[. + ":9113"], labels:{job:"nginx"}}' \
  | jq -s . > "$OUT/nginx.json"
