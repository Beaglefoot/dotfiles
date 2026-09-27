# Automated Encrypted Backup Setup Guide (openSUSE Slowroll)

This guide walks you through setting up a secure, automated, and encrypted nightly backup system. This setup uses a hardware-bound USB drive ID, decouples your sensitive credentials into an isolated environment file, runs an accumulative sync via **rsync**, and automates execution via **systemd user timers** (which gracefully handle system sleep/wake cycles).

---

### Step 1: Find the Persistent USB Drive ID
VeraCrypt hides the standard filesystem labels while a partition is locked. To find a unique, persistent path for your drive that never changes even if you change USB ports:
1. Plug your encrypted drive into the computer.
2. List the connected disk IDs:
   ```bash
   ls -l /dev/disk/by-id/
   ```
3. Locate the entry corresponding to your external drive (for example, `usb-TOSHIBA_MQ01ABD100_XXXXXXXXXXXX-0:0`). Keep this value ready for Step 3.

---

### Step 2: Configure Passwordless Background Privileges
Because VeraCrypt communicates with the Linux kernel to assign loop block devices, it requires root permissions. To allow your systemd background tasks to run VeraCrypt without stopping to ask for a password, you must configure a secure `sudoers` rule.

1. Open the system privileges configuration file:
   ```bash
   sudo EDITOR=vi visudo
   ```
2. Scroll to the very bottom of the file and paste this rule (replace `yourusername` with your actual system username):
   ```text
   yourusername ALL=(root) NOPASSWD: /usr/bin/veracrypt, /usr/bin/true
   ```

---

### Step 3: Create the Secured Environment File
To prevent your plain-text password or drive configuration from being stored inside a reusable code script, create an isolated configuration file.

1. Generate and edit the file:
   ```bash
   vi ~/.config/backup-env
   ```
2. Paste the variables exactly as shown, filling in your true details:
   ```text
   VC_PASSWORD=YourActualVeraCryptPassword
   DISK_ID=usb-TOSHIBA_MQ01ABD100_XXXXXXXXXXXX-0:0
   ```
3. **Lock down permissions** so no other user or application on your computer can read this file:
   ```bash
   chmod 600 ~/.config/backup-env
   ```

---

### Step 4: Write the Backup Script (`nightly_backup.sh`)
Create the core script that manages checking for the disk, decrypting it, performing the sync, and spinning it down.

1. Create a directory for your scripts and open the file:
   ```bash
   mkdir -p ~/.scripts
   vi ~/.scripts/nightly_backup.sh
   ```
2. Paste the following complete code block:
   ```bash
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

   # 2. Native veracrypt invocation
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
   ```
3. Give the script executable permissions:
   ```bash
   chmod +x ~/.scripts/nightly_backup.sh
   ```

---

### Step 5: Automate via Systemd User Units
Create the background system services to handle the scheduling. Unlike old-school cron jobs, systemd will run your task immediately upon awakening if your PC was turned off or asleep when the scheduled hour struck.

1. Create the systemd user configuration directory:
   ```bash
   mkdir -p ~/.config/systemd/user/
   ```
2. Create and edit the **Service Unit** file (`~/.config/systemd/user/nightly-backup.service`):
   ```bash
   vi ~/.config/systemd/user/nightly-backup.service
   ```
3. Paste the following configuration:
   ```ini
   [Unit]
   Description=Nightly incremental backup to VeraCrypt BackupDrive
   After=local-fs.target

   [Service]
   Type=oneshot
   EnvironmentFile=%h/.config/backup-env
   ExecStart=%h/.scripts/nightly_backup.sh

   [Install]
   WantedBy=default.target
   ```
4. Create and edit the **Timer Unit** file (`~/.config/systemd/user/nightly-backup.timer`):
   ```bash
   vi ~/.config/systemd/user/nightly-backup.timer
   ```
5. Paste the following configuration:
   ```ini
   [Unit]
   Description=Run nightly backup script daily

   [Timer]
   # Triggers every single night at 2:00 AM
   OnCalendar=*-*-* 02:00:00
   # Catch-up if the computer was asleep during the 2:00 AM window
   Persistent=true

   [Install]
   WantedBy=timers.target
   ```

---

### Step 6: Activate and Verify
With all the configuration layers configured, enable the automations and test your environment.

1. Force systemd to load the new config files, and set the timer to run automatically on your account logs:
   ```bash
   systemctl --user daemon-reload
   systemctl --user enable --now nightly-backup.timer
   ```
2. **Manually run an execution test right now** to confirm that permissions, unlocking, and file transfers are working:
   ```bash
   systemctl --user start nightly-backup.service
   ```
3. Check the internal logging output generated by the script:
   ```bash
   cat ~/.local/share/backup-logs/backup_$(date +%Y-%m-%d).log
   ```

---

### Managing and Checking Status Later
* **To check when it will run next:** `systemctl --user list-timers nightly-backup.timer`
* **To check background system errors:** `journalctl --user -u nightly-backup.service`
