#!/bin/bash

# /root/tuxedo-yt6801_1.0.28-1_all.deb
# oder
# /root/tuxedo-yt6801_1.0.30tux5_all.deb   mindestens eine deb MUSS vorhanden sein!!!

# Da Cron eingeschränkten PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# --- Konfiguration ---

DEBUG=false

DEB_PKG1="/root/tuxedo-yt6801_1.0.28-1_all.deb"
DEB_PKG2="/root/tuxedo-yt6801_1.0.30tux5_all.deb"

PING_TARGET="192.168.1.1"                     # Hier Router/Gateway IP eintragen!!!
LOGFILE="/var/log/yt6801-autoinstall.log"

mkdir -p /var/log
touch "$LOGFILE"

MARKER="/root/yt6801_stage"

if [ ! -f "$MARKER" ]; then
    echo 0 > "$MARKER"
fi

STAGE=$(cat "$MARKER")

log() {
    echo "$(date '+%F %T') - $1" | tee -a "$LOGFILE"
}

log ""
log "=== Start yt6801 Auto-Installer ==="

sleep 10

# --- Netzwerk testen ---
if ping -c 1 -W 2 $PING_TARGET &>/dev/null; then
    log "Netzwerk funktioniert, keine Aktion notwendig."
    echo 0 > "$MARKER"
    exit 0
else
    log "Netzwerk nicht erreichbar, starte Treiberinstallation..."
fi

# --- Stage erhöhen ---
STAGE=$((STAGE + 1))
echo "$STAGE" > "$MARKER"

log "Stage: $STAGE"

# --- Treiberwahl ---
if [ "$STAGE" -eq 1 ]; then
    DEB_PKG="$DEB_PKG1"
elif [ "$STAGE" -eq 2 ]; then
    DEB_PKG="$DEB_PKG2"
else
    log "Keine Treiberinstallation erfolgreich!"
    exit 1
fi

# --- Deb-Paket installieren ---
if [ -f "$DEB_PKG" ]; then
    log "Installiere Deb-Paket $DEB_PKG ..."
    if [ "$DEBUG" = false ]; then
        if ! dpkg -i "$DEB_PKG" >> "$LOGFILE" 2>&1; then
            log "dpkg-Installation fehlgeschlagen!"
            exit 1
        fi
    fi
else
    log "Deb-Paket $DEB_PKG nicht gefunden!"
    exit 1
fi

# --- Modul dauerhaft laden ---
if [ "$DEBUG" = false ]; then
    if ! grep -qxF "yt6801" /etc/modules; then
        echo yt6801 | tee -a /etc/modules >> "$LOGFILE" 2>&1
    fi

    # --- Abhängigkeiten neu einlesen ---
    depmod >> "$LOGFILE" 2>&1
fi

# --- Prüfen, ob Modul geladen ist ---
if lsmod | grep -q yt6801; then
    log "Treiber bereits geladen!"
elif [ "$DEBUG" = false ]; then
    log "Lade Kernel-Modul yt6801 ..."
    modprobe yt6801 >> "$LOGFILE" 2>&1
fi

# --- Anzeige ---
lsmod | grep yt6801 | tee -a "$LOGFILE"

log "=== Fertig ==="
log "Treiber ist geladen. reboot..."

if [ "$DEBUG" = false ]; then
    reboot
else
    log "DEBUG: Kein Reboot."
fi

