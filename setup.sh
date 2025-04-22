#!/bin/bash

# === Overseer Install-Package ===
# Dieses Script richtet den User 'overseer', SSH-Zugang und das dynamische MOTD ein.

USERNAME="overseer"
SSH_KEY="$(cat authorized_keys)"
MOTD_SCRIPT_PATH="/etc/update-motd.d/10-teletraan-motd"
DESCRIPTION_FILE="/etc/motd_description.txt"

echo "🔧 Starte Grundkonfiguration..."

# User anlegen
if id "$USERNAME" &>/dev/null; then
    echo "✅ User $USERNAME existiert bereits."
else
    sudo adduser $USERNAME
    sudo usermod -aG sudo $USERNAME
    echo "✅ User $USERNAME wurde erstellt und zur sudo-Gruppe hinzugefügt."
fi

# SSH Key einrichten
sudo -u $USERNAME mkdir -p /home/$USERNAME/.ssh
echo "$SSH_KEY_
