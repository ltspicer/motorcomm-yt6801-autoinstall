#!/bin/bash

################################# motorcomm-yt6801-autoinstall ####################################

# Dieses Script nach /root kopieren und ausführbar machen ( chmod a+x /root/yt6801-autoinstall.sh )

# Cron Eintrag:

# @reboot /root/yt6801-autoinstall.sh

###################################################################################################

# /root/tuxedo-yt6801_1.0.28-1_all.deb
# oder/und
# /root/tuxedo-yt6801_1.0.30tux5_all.deb   mindestens eine DEB (DEB_PKG1) MUSS vorhanden sein!!!

###################################################################################################

# Da Cron eingeschränkten PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

#################### --- Konfiguration --- ####################

DEB_PKG1="$SCRIPT_DIR/tuxedo-yt6801_1.0.28-1_all.deb"
DEB_PKG2="$SCRIPT_DIR/tuxedo-yt6801_1.0.30tux5_all.deb"

PING_TARGET="192.168.1.1"                             # !!! Hier Router/Gateway IP eintragen !!!

####

LOGFILE="/var/log/yt6801-autoinstall.log"
MARKER="$SCRIPT_DIR/yt6801_stage"

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

mkdir -p /var/log
touch "$LOGFILE"

if [ ! -f "$MARKER" ]; then
    echo 0 > "$MARKER"
fi

STAGE=$(cat "$MARKER")

log ""
log "=== Start yt6801 Auto-Installer ==="

NETWORK_OK=false

for i in {1..10}; do
    log "Warte auf Netzwerk... Versuch $i/10"
    if ping -c 1 -W 1 "$PING_TARGET" &>/dev/null; then
        log "Netzwerk erreichbar nach $i Versuch(en)"
        NETWORK_OK=true
        break
    fi
    sleep 1
done

if [[ $NETWORK_OK == false ]]; then
    log "Netzwerk nach 10 Versuchen NICHT erreichbar!"
fi

if [ "$DEBUG" = true ]; then
    log "DEBUG aktiviert"
    if [ -f "$DEB_PKG1" ]; then
        log "Deb-Paket $DEB_PKG1 gefunden :D"
    else
        log "Deb-Paket $DEB_PKG1 nicht gefunden!"
    fi
    if [ -f "$DEB_PKG2" ]; then
        log "Deb-Paket $DEB_PKG2 gefunden :D"
    else
        log "Deb-Paket $DEB_PKG2 nicht gefunden!"
    fi
fi

# --- Netzwerk testen ---
if [[ $NETWORK_OK == true ]]; then
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
    if [ -f "$DEB_PKG2" ]; then
        DEB_PKG="$DEB_PKG2"
    else
        log "Fallback: DEB_PKG2 nicht vorhanden, verwende DEB_PKG1 erneut"
        DEB_PKG="$DEB_PKG1"
    fi
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
    else
        log "DEBUG: Keine Installation"
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
else
    log "DEBUG: modprobe yt6801 nicht ausgeführt"
fi

# --- Anzeige ---
lsmod | grep yt6801 | tee -a "$LOGFILE"

log "=== Fertig ==="
log "Treiber ist geladen. reboot..."

if [ "$DEBUG" = false ]; then
    reboot
else
    log "DEBUG: Kein Reboot. Stage wieder auf 0 gestellt."
    echo 0 > "$MARKER"
fi

