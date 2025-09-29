# Homelab Init - Overseer Setup

Dieses Repository enthält die Setup-Skripte für den Benutzer **overseer** in deinem Homelab.  
Es richtet eine einheitliche Umgebung für alle Systeme ein (MOTD, SSH, Pakete, User).

## 📦 Inhalt
- `install_overseer.sh` → Installiert den Benutzer `overseer`, SSH-Keys, Basis-Pakete, MOTD (Multiverse Edition)
- `rollback_overseer.sh` → Entfernt die Änderungen (MOTD, sudoers, SSH-Anpassungen, optional den Benutzer)
- `00-overseer.sh` → Dynamisches MOTD-Skript mit Systeminfos und Zitaten aus Star Wars, Star Trek, Transformers, Marvel und Fallout
- `fallout_motd.txt` → Bonus: Klassisches Fallout-MOTD
- `authorized_keys` → SSH-Public Keys für den Benutzer `overseer`
- `ssh_config` → SSH-Client Konfigurationsdatei

## 🚀 Installation
```bash
git clone https://github.com/gitlingg/homelab-init.git
cd homelab-init
sudo ./install_overseer.sh
```

Nach der Installation:
- Anmeldung per SSH mit dem Benutzer **overseer**
- Passwort-Login ist deaktiviert, nur SSH-Key-Auth erlaubt
- Login zeigt dynamisches Multiverse-MOTD

## ⏪ Rollback
Falls du die Änderungen zurücksetzen willst:
```bash
sudo ./rollback_overseer.sh
```

Während des Rollbacks kannst du optional den Benutzer `overseer` löschen.

---

✨ **Multiverse MOTD** zeigt Systeminfos + kleine Easter Eggs aus deinen Universen:
- Star Trek → "Engage!"
- Star Wars → "The Force is with you"
- Transformers → "Till all are one"
- Marvel → "I am Iron Man"
- Fallout → "War never changes"
