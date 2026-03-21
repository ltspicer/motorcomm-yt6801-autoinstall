# motorcomm-yt6801-autoinstall
## Selbständige Installation des motorcomm-yt6801 Treibers nach einem Kernel Update

Da dieser Treiber nicht im Linux Kernel integriert ist, kann das LAN nach einem Boot fehlen.
Es ist dann keine Netzwerkverbindung möglich.

Bei Headless-Servern (ohne angeschlossenen Bildschirm) wie zBsp. bei Proxmox Servern ist das ziemlich ärgerlich und aufwändig, wieder eine SSH Session zu bekommen.

Da DKMS in diesem Fall auch nicht zuverlässig funktioniert, habe ich ein autoinstall Script erstellt,
welches nach einem Reboot aufgerufen wird.

Dieses prüft beim Boot, ob eine Verbindung zum Router/Gateway besteht. Wenn nicht, wird der yt6801 Treiber automatisch installiert.

Es kann nach einem Boot 5-10 Minuten dauern, bis die Netzwerkverbindung steht. Also nicht verzweifeln und etwas Geduld haben ;)

Ich empfehle, das Script zuerst im laufenden Betrieb mal mit Option "-debug" auszuführen und dann den log zu prüfen ( /var/log/yt6801-autoinstall.log ).

Beispiel:

./net_check.sh -help


**yt6801-autoinstall.sh** & **tuxedo-yt6801_1.0.28-1_all.deb** & **tuxedo-yt6801_1.0.30tux5_all.deb** & **net_check.sh** ins **/root** Verzeichnis kopieren.

Ausführbar machen:

**chmod a+x /root/yt6801-autoinstall.sh /root/net_check.sh**

**crontab -e** # Dies als root ausführen (sudo)!

Eintragen/hinzufügen im Cron:

        @reboot /root/yt6801-autoinstall.sh
        */15 * * * * /root/net_check.sh

Jetzt speichern.

**Oder** mit diesem Einzeiler (Du musst als root eingeloggt sein!):

        cd /root && git clone https://github.com/ltspicer/motorcomm-yt6801-autoinstall.git && cd motorcomm-yt6801-autoinstall && chmod a+x yt6801-autoinstall.sh net_check.sh && (crontab -l 2>/dev/null | grep -v -E 'yt6801-autoinstall.sh|net_check.sh'; echo "@reboot /root/motorcomm-yt6801-autoinstall/yt6801-autoinstall.sh"; echo "*/15 * * * * /root/motorcomm-yt6801-autoinstall/net_check.sh") | crontab -

**Unbedingt die Router/Gateway IP in beiden Scripten eintragen!**

---------------------------------------------

## Autoinstall of motorcomm-yt6801 driver after Kernel update

Since this driver is not built into the Linux kernel, the LAN connection may be missing after a reboot.
In that case, no network connection is possible.

With headless servers (without a connected monitor), such as Proxmox servers, it’s quite frustrating and time-consuming to re-establish an SSH session.

Since DKMS does not work reliably in this case either, I created an autoinstall script
that is called after a reboot.

During startup, this checks whether there is a connection to the router/gateway. If not, the yt6801 driver is installed automatically.

It may take 5–10 minutes after booting up for the network connection to be established. So don’t worry—just be patient ;)

I recommend running the script first with option “-debug” while the system is running, and then checking the log ( /var/log/yt6801-autoinstall.log ).

Example:

./net_check.sh -help


Copy **yt6801-autoinstall.sh** & **tuxedo-yt6801_1.0.28-1_all.deb** & **tuxedo-yt6801_1.0.30tux5_all.deb** & **net_check.sh** to the **/root** directory.

Make executable:

**chmod a+x /root/yt6801-autoinstall.sh /root/net_check.sh**

**crontab -e** # Run this as root (sudo)!

Enter/add in Cron:

        @reboot /root/yt6801-autoinstall.sh
        */15 * * * * /root/net_check.sh

Save now.

**Or** with this one-liner (You must be logged in as root!):

        cd /root && git clone https://github.com/ltspicer/motorcomm-yt6801-autoinstall.git && cd motorcomm-yt6801-autoinstall && chmod a+x yt6801-autoinstall.sh net_check.sh && (crontab -l 2>/dev/null | grep -v -E 'yt6801-autoinstall.sh|net_check.sh'; echo "@reboot /root/motorcomm-yt6801-autoinstall/yt6801-autoinstall.sh"; echo "*/15 * * * * /root/motorcomm-yt6801-autoinstall/net_check.sh") | crontab -

**Be sure to enter the router/gateway IP address in both scripts!**
