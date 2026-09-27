#!/bin/bash

# --- CONFIGURATION ---
SOURCE_DIRS=("$HOME/Books" "$HOME/Documents" "$HOME/Music" "$HOME/Pictures" "$HOME/Videos")
MOUNT_POINT="$HOME/mnt/BackupDrive"
# ---------------------

# Log setup
LOG_DIR="$HOME/.local/share/backup-logs"
mkdir -p "$LOG_DIR"
CURRENT_LOG="$LOG_DIR/backup_$(date +%Y-%m-%d).log"

DISK_PATH="/dev/disk/by-id/$DISK_ID"

# 1. Check if the physical drive is plugged in
if [ ! -b "$DISK_PATH" ]; then
    echo "$(date): Backup skipped. Encrypted drive ($DISK_ID) is not attached." >> "$CURRENT_LOG"
    exit 0
fi

mkdir -p "$MOUNT_POINT"

echo "$(date): Drive detected. Unlocking using environment variables..." >> "$CURRENT_LOG"

# 2. Native veracrypt invocation (will internally call the visudo rules in the background)
veracrypt -t --non-interactive -p "$VC_PASSWORD" "$DISK_PATH" "$MOUNT_POINT" >> "$CURRENT_LOG" 2>&1

# 3. Verify the mount succeeded
if ! mountpoint -q "$MOUNT_POINT"; then
    echo "$(date): Backup failed. Mount point verification failed." >> "$CURRENT_LOG"
    exit 1
fi

echo "$(date): Backup started to encrypted $MOUNT_POINT (Accumulative mode)..." >> "$CURRENT_LOG"

# 4. Sync directories
for DIR in "${SOURCE_DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        rsync -av "$DIR/" "$MOUNT_POINT/$(basename "$DIR")/" >> "$CURRENT_LOG" 2>&1
    else
        echo "$(date): Warning: Source directory $DIR does not exist." >> "$CURRENT_LOG"
    fi
done

echo "$(date): Backup successfully completed. Dismounting and locking drive..." >> "$CURRENT_LOG"

# 5. Native dismount
veracrypt -u "$DISK_PATH" >> "$CURRENT_LOG" 2>&1

# --- LOG ROTATION ---
find "$LOG_DIR" -name "backup_*.log" -type f -mtime +7 -delete
