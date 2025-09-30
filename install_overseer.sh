#!/bin/bash
# === overseer setup script (aktualisiert 2025) ===

set -e

echo "🔧 Starte Overseer Setup..."

USER_NAME="overseer"

# --- Benutzer anlegen ---
if id "$USER_NAME" &>/dev/null; then
    echo "✅ Benutzer '$USER_NAME' existiert bereits."
else
    echo "➕ Benutzer '$USER_NAME' wird erstellt..."
    adduser --disabled-password --gecos "" $USER_NAME
fi

# --- SSH-Keys einrichten ---
echo "📁 Erstelle SSH-Verzeichnis..."
mkdir -p /home/$USER_NAME/.ssh
cp authorized_keys /home/$USER_NAME/.ssh/authorized_keys
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh
chmod 700 /home/$USER_NAME/.ssh
chmod 600 /home/$USER_NAME/.ssh/authorized_keys

echo "==> SSH absichern..."

# Root-Login verbieten
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# Nur Schlüssel-Login erlauben
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config

# Optional: sicherstellen, dass PAM aktiv bleibt
sudo sed -i 's/^#*UsePAM.*/UsePAM yes/' /etc/ssh/sshd_config

# SSH-Dienst neu starten
sudo systemctl restart ssh

# --- Sudo Rechte ---
echo "⚡ Setze Sudo-Rechte..."
echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME
chmod 440 /etc/sudoers.d/$USER_NAME

# --- Basis-Pakete installieren ---
echo "📦 Installiere Basis-Pakete..."
apt update
apt install -y vim htop curl git net-tools nfs-common lsb-release jq

# --- MOTD Setup ---
echo "🖼️ Installiere Login-Banner..."
cp fallout_motd.txt /etc/motd
# modern: eigenes Skript für dynamische Infos
cp 00-overseer.sh /etc/update-motd.d/00-overseer
chmod +x /etc/update-motd.d/00-overseer

# --- SSH absichern ---
echo "🔒 Sichere SSH..."
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

echo "✅ Setup abgeschlossen! Du kannst dich nun als '$USER_NAME' per SSH anmelden."
