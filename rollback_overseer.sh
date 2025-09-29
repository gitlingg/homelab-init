#!/bin/bash
# === overseer rollback script (2025) ===

set -e

USER_NAME="overseer"

echo "⏪ Starte Overseer Rollback..."

# --- MOTD zurücksetzen ---
echo "🗑️ Entferne MOTD-Skripte..."
rm -f /etc/update-motd.d/00-overseer
echo "Welcome to your system." > /etc/motd

# --- Sudo Rechte entfernen ---
if [ -f "/etc/sudoers.d/$USER_NAME" ]; then
    echo "🗑️ Entferne Sudo-Rechte..."
    rm -f /etc/sudoers.d/$USER_NAME
fi

# --- SSH Defaults zurücksetzen ---
echo "🔧 Setze SSH Defaults zurück..."
sed -i 's/^PermitRootLogin.*/#PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/#PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

# --- overseer User optional löschen ---
read -p "Soll der Benutzer '$USER_NAME' komplett entfernt werden? (y/N): " CONFIRM
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "🗑️ Entferne Benutzer '$USER_NAME'..."
    deluser --remove-home $USER_NAME || true
fi

echo "✅ Rollback abgeschlossen."
