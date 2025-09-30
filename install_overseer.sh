#!/bin/bash
set -e

### homelab-init ###
# Initial-Setup für Debian/Ubuntu Systeme
# User: overseer
# Erstellt MOTD, Hardening, SSH-Anpassungen

# --- Vorbereitungen ---
if [ "$(id -u)" -ne 0 ]; then
  echo "[ERROR] Dieses Skript muss als root ausgeführt werden."
  exit 1
fi

echo "[INFO] Update Paketquellen..."
apt update -y
apt upgrade -y

# --- sudo sicherstellen ---
if ! command -v sudo >/dev/null 2>&1; then
  echo "[INFO] sudo wird installiert..."
  apt install -y sudo
fi

# --- User overseer ---
if id "overseer" &>/dev/null; then
  echo "[INFO] Benutzer overseer existiert bereits."
else
  echo "[INFO] Erstelle Benutzer overseer..."
  adduser --disabled-password --gecos "" overseer
  echo "overseer ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/overseer
fi

# overseer in sudo-Gruppe aufnehmen
if id -nG overseer | grep -qw sudo; then
  echo "[INFO] overseer ist bereits in der sudo-Gruppe."
else
  usermod -aG sudo overseer
  echo "[INFO] overseer zur sudo-Gruppe hinzugefügt."
fi

# --- SSH Hardening ---
echo "[INFO] Passe SSH-Konfiguration an..."
SSHD_CONFIG="/etc/ssh/sshd_config"

# Backup erstellen
if [ ! -f "${SSHD_CONFIG}.bak" ]; then
  cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak"
fi

# Basis-Hardening
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' $SSHD_CONFIG
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' $SSHD_CONFIG
sed -i 's/^#*PermitEmptyPasswords.*/PermitEmptyPasswords no/' $SSHD_CONFIG

# SSH neu starten (kompatibel für Ubuntu/Debian)
if systemctl list-unit-files | grep -q '^ssh\.service'; then
  systemctl restart ssh
elif systemctl list-unit-files | grep -q '^sshd\.service'; then
  systemctl restart sshd
else
  echo "[WARN] Kein SSH-Dienst gefunden – bitte manuell prüfen."
fi

# --- MOTD ---
echo "[INFO] Richte dynamisches MOTD ein..."
MOTD_SCRIPT="/etc/update-motd.d/10-homelab"

cat > "$MOTD_SCRIPT" <<'EOF'
#!/bin/bash
echo "----------------------------------"
echo " Hostname: $(hostname)"
echo " OS:       $(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
echo " Kernel:   $(uname -r)"
echo " Uptime:   $(uptime -p)"
echo " IP:       $(hostname -I | awk '{print $1}')"
echo "----------------------------------"
EOF

chmod +x "$MOTD_SCRIPT"

# --- Fertig ---
echo "[INFO] Setup abgeschlossen. Bitte einmal mit overseer einloggen."
