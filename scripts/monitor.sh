#!/bin/bash

# Définition des répertoires
WATCHED_DIR="/home/$USER/Documents/important"   # Dossier à surveiller
BACKUP_DIR="/home/$USER/backups"                # Dossier de sauvegarde
LOG_FILE="/var/log/monitor_backup.log"          # Fichier log

# Création des répertoires s’ils n’existent pas
mkdir -p "$WATCHED_DIR" "$BACKUP_DIR"

# Log de démarrage
echo "$(date '+%F %T') : Surveillance démarrée sur $WATCHED_DIR" >> "$LOG_FILE"

# Surveillance continue du dossier
while true; do
    # Déclenchement lors d’un changement
    inotifywait -r -e modify,create,delete "$WATCHED_DIR"

    # Création de la sauvegarde avec horodatage
    TIMESTAMP=$(date '+%F_%H-%M-%S')
    DEST="$BACKUP_DIR/sauvegarde_$TIMESTAMP"
    cp -r "$WATCHED_DIR" "$DEST"

    # Log de sauvegarde
    echo "$(date '+%F %T') : Changement détecté, backup créé dans $DEST" >> "$LOG_FILE"
done
