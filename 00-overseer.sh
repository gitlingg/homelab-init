#!/bin/bash
# === Overseer MOTD Script (Multiverse Edition) ===

HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
LOAD=$(cut -d " " -f1-3 < /proc/loadavg)
MEM=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
DISK=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
IPADDR=$(hostname -I | awk '{print $1}')

echo -e "
╔════════════════════════════════════════════╗
║   🛰️  Overseer Multiverse Node             ║
╚════════════════════════════════════════════╝

  🔹 Hostname : $HOSTNAME
  🔹 IP Addr  : $IPADDR
  🔹 Uptime   : $UPTIME
  🔹 Load     : $LOAD
  🔹 Memory   : $MEM
  🔹 Disk     : $DISK

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Universes Online: 
   ✦ Star Trek      → \"Engage!\"
   ✦ Star Wars      → \"The Force is with you\"
   ✦ Transformers   → \"Till all are one\"
   ✦ Marvel         → \"I am Iron Man\"
   ✦ Fallout        → \"War never changes\"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
