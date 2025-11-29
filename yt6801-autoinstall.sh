#!/bin/bash

# Info:
# /root/tuxedo-yt6801_1.0.28-1_all.deb   MUSS vorhanden sein!!!

# crontab -e
# @reboot /root/yt6801-autoinstall.sh

PING_TARGET="192.168.1.100"         # Hier Router/Gateway IP eintragen!!!

######################################

# Ab hier keine Eintragungen notwendig

# Da Cron eingeschränkten PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# --- Konfiguration ---
DEB_PKG="/root/tuxedo-yt6801_1.0.28-1_all.deb"
LOGFILE="/var/log/yt6801-autoinstall.log"

log() {
    echo "$(date '+%F %T') - $1" | tee -a "$LOGFILE"
}

log "=== Start yt6801 Auto-Installer ==="

# --- Netzwerk testen ---
if ping -c 1 -W 2 $PING_TARGET &>/dev/null; then
    log "Netzwerk funktioniert, keine Aktion notwendig."
    exit 0
else
    log "Netzwerk nicht erreichbar, starte Treiberinstallation..."
fi

# --- Deb-Paket installieren ---
if [ -f "$DEB_PKG" ]; then
    log "Installiere Deb-Paket $DEB_PKG ..."
    dpkg -i "$DEB_PKG" >> "$LOGFILE" 2>&1
else
    log "Deb-Paket $DEB_PKG nicht gefunden!"
    exit 1
fi

# --- Modul dauerhaft laden ---
echo yt6801 | tee -a /etc/modules >> "$LOGFILE" 2>&1

# --- Abhängigkeiten neu einlesen ---
depmod >> "$LOGFILE" 2>&1

# --- Prüfen, ob Modul geladen ist ---
if lsmod | grep -q yt6801; then
    log "Treiber bereits geladen!"
else
    log "Lade Kernel-Modul yt6801 ..."
    modprobe yt6801 >> "$LOGFILE" 2>&1
fi

# --- Anzeige ---
lsmod | grep yt6801 | tee -a "$LOGFILE"

log "=== Fertig ==="
log "Treiber ist geladen. reboot..."
reboot
