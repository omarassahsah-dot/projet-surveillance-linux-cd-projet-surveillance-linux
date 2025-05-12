# ---------- scripts/monitor.sh ----------
#!/bin/bash
# Script de surveillance d'un dossier avec inotifywait
# Surveille ~/Documents/important et enregistre les événements

WATCH_DIR="$HOME/Documents/important"
LOG_FILE="/var/log/monitor_backup.log"

mkdir -p "$WATCH_DIR"

inotifywait -m "$WATCH_DIR" -e create -e modify -e delete --format '%T %w %e %f' --timefmt '%F %T' |
while read date time dir event file; do
  echo "$date $time - Evenement: $event - Fichier: $file" >> "$LOG_FILE"
  # Optionnel : lancer un backup ici automatiquement
  # /opt/backup_daily.sh "$WATCH_DIR"
done

# ---------- scripts/backup_daily.sh ----------
#!/bin/bash
# Script de sauvegarde quotidienne du dossier surveillé

SOURCE_DIR="$HOME/Documents/important"
BACKUP_DIR="$HOME/backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
DEST="$BACKUP_DIR/backup_$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"
tar -czf "$DEST" "$SOURCE_DIR"
echo "[$(date)] Backup enregistré : $DEST" >> /var/log/monitor_backup.log

# ---------- systemd/monitor.service ----------
[Unit]
Description=Service de surveillance de fichiers
After=network.target

[Service]
Type=simple
ExecStart=/opt/monitor.sh
Restart=always
User=your_username

[Install]
WantedBy=multi-user.target

# ---------- systemd/backup-daily.service ----------
[Unit]
Description=Sauvegarde quotidienne automatique du dossier surveillé

[Service]
Type=oneshot
ExecStart=/opt/backup_daily.sh
User=your_username

# ---------- systemd/backup-daily.timer ----------
[Unit]
Description=Timer pour sauvegarde quotidienne

[Timer]
OnCalendar=daily
Persistent=true
Unit=backup-daily.service

[Install]
WantedBy=timers.target

# ---------- .gitignore ----------
*.log
log/
backups/

# ---------- README.md ----------
# Projet Linux – Surveillance & Sauvegarde

Ce projet permet de surveiller un dossier spécifique sur Linux et de sauvegarder automatiquement son contenu grâce à des scripts bash et systemd.

## Contenu
- Surveillance de ~/Documents/important avec inotify
- Backup compressé automatique avec systemd.timer
- Stockage dans ~/backups
- Journalisation dans /var/log/monitor_backup.log

## Installation
```bash
sudo cp scripts/*.sh /opt/
sudo chmod +x /opt/*.sh
sudo cp systemd/*.service /etc/systemd/system/
sudo cp systemd/*.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now monitor.service
sudo systemctl enable --now backup-daily.timer
```

## Auteur
TP Linux 2025

# ---------- LICENSE (optionnel) ----------
MIT License
