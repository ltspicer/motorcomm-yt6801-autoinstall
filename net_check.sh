#!/bin/bash

################### Periodische Überprüfung der Netzwerkverbindung #######################

# Dieses Script nach /root kopieren und ausführbar machen ( chmod a+x /root/net_check.sh )

# Cron Eintrag:

# */15 * * * * /root/net_check.sh

##########################################################################################

# Da Cron eingeschränkten PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#################### --- Konfiguration --- ####################

PING_TARGET="192.168.1.1"                       # Gleich wie in yt6801-autoinstall.sh
LOGFILE="/var/log/yt6801-autoinstall.log"       # Gleich wie in yt6801-autoinstall.sh
MARKER="/root/yt6801_stage"                     # Gleich wie in yt6801-autoinstall.sh

############ --- Ab hier keine Änderungen mehr --- ############

log() {
    echo "$(date '+%F %T') - $1" | tee -a "$LOGFILE"
}

DEBUG=false

# Hilfe-Funktion
show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -debug, debug                   Enable debug mode"
    echo "  -h, -help, -?, ?, h, help       Show this help message"
    exit 0
}

# Argumente prüfen
for arg in "$@"; do
    case "${arg,,}" in
        debug|-debug)
            DEBUG=true
            ;;
        -h|-help|-?|h|help|\?)
            show_help
            ;;
    esac
done

if [ "$DEBUG" = true ]; then
    log "DEBUG aktiviert"
fi

mkdir -p /var/log
touch "$LOGFILE"

if [ ! -f "$MARKER" ]; then
    log "Keine Datei $MARKER gefunden. Exit"
    exit 0
fi

STAGE=$(cat "$MARKER")

# --- Netzwerk testen ---
if ping -c 1 -W 2 $PING_TARGET &>/dev/null; then
    if [ "$STAGE" -eq 3 ]; then
        echo 0 > "$MARKER"
        log "Netzwerk funktioniert. Setze Stage auf 0"
    fi
    if [ "$DEBUG" = "true" ]; then
        log "Ping erfolgreich"
    fi
    exit 0
else
    if [ "$DEBUG" = "true" ]; then
        log "Ping nicht erfolgreich ( $MARKER auf $STAGE belassen)"
        log "PING_TARGET = $PING_TARGET . Ist das korrekt?"
    fi
fi

