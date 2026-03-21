#!/bin/bash

# Dieses Script nach /root kopieren und ausführbar machen ( chmod a+x /root/net_check.sh )
#
# Cron Eintrag:
#
# */5 * * * * /root/net_check.sh

# Da Cron eingeschränkten PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# --- Konfiguration ---

DEBUG=false

PING_TARGET="192.168.1.1"                       # Gleich wie in yt6801-autoinstall.sh
LOGFILE="/var/log/yt6801-autoinstall.log"       # Gleich wie in yt6801-autoinstall.sh
MARKER="/root/yt6801_stage"                     # Gleich wie in yt6801-autoinstall.sh

mkdir -p /var/log                               # Gleich wie in yt6801-autoinstall.sh
touch "$LOGFILE"

# --- Ab hier keine Änderungen mehr ---

log() {
    echo "$(date '+%F %T') - $1" | tee -a "$LOGFILE"
}

if [ ! -f "$MARKER" ]; then
    if [ "$DEBUG" = "true" ]; then
        log "=== Keine Datei $MARKER gefunden. Exit ==="
        exit 0
    fi
fi

STAGE=$(cat "$MARKER")

# --- Netzwerk testen ---
if ping -c 1 -W 2 $PING_TARGET &>/dev/null; then
    if [ "$STAGE" -ne 0 ]; then
        echo 0 > "$MARKER"
        log "=== Stage auf 0 gesetzt ==="
    fi
    if [ "$DEBUG" = "true" ]; then
        log "=== Ping erfolgreich ==="
    fi
    exit 0
else
    if [ "$DEBUG" = "true" ]; then
        log "=== Ping nicht erfolgreich (Stage belassen)==="
        log "PING_TARGET = $PING_TARGET . Ist das korrekt?"
    fi
fi

