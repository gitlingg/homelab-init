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
# Restore SSH defaults (falls man sich ausgesperrt hat)

echo "==> SSH auf Default-Einstellungen zurücksetzen..."

# Root-Login wieder erlauben
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Passwort-Login wieder erlauben
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config

# PAM bleibt unverändert
sudo sed -i 's/^#*UsePAM.*/UsePAM yes/' /etc/ssh/sshd_config

# Dienst neu starten
sudo systemctl restart ssh

echo "==> SSH ist wieder offen: Root & Passwort-Login erlaubt."
echo "    Nutze das nur für Notfälle und ändere es danach wieder zurück!"



# --- overseer User optional löschen ---
read -p "Soll der Benutzer '$USER_NAME' komplett entfernt werden? (y/N): " CONFIRM
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "🗑️ Entferne Benutzer '$USER_NAME'..."
    deluser --remove-home $USER_NAME || true
fi

echo "✅ Rollback abgeschlossen."
