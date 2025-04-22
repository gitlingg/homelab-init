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
echo "$SSH_KEY" | sudo tee /home/$USERNAME/.ssh/authorized_keys > /dev/null
sudo chmod 700 /home/$USERNAME/.ssh
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
echo "✅ SSH-Key für $USERNAME hinterlegt."

# MOTD Script kopieren
sudo cp motd_script/10-teletraan-motd $MOTD_SCRIPT_PATH
sudo chmod +x $MOTD_SCRIPT_PATH
echo "✅ Dynamisches MOTD installiert."

# Beschreibungsvorlage kopieren
if [ ! -f "$DESCRIPTION_FILE" ]; then
    sudo cp motd_script/motd_description.txt $DESCRIPTION_FILE
    echo "ℹ️  Bitte passe die Systembeschreibung in $DESCRIPTION_FILE an."
fi

echo "🎉 Setup abgeschlossen! Teste dein MOTD mit: ssh $USERNAME@hostname"
