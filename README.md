# motorcomm-yt6801-autoinstall
## Selbständige Installation des motorcomm-yt6801 Treibers nach einem Kernel Update

Da dieser Treiber nicht automatisch von Linux erkannt wird, können Bootprobleme entstehn.
Es ist keine Netzwerk verbindung mehr möglich.
Bei Servern ohne Bildschirm wie zBsp. bei Proxmox ist das ziemlich ärgerlich und aufwändig.
Da DKMS in diesem Fall auch nicht zuverlässig funktioniert, habe ich ein autoinstall Script erstellt,
welches nach einem Reboot aufgerufen wird.


**yt6801-autoinstall.sh** & **tuxedo-yt6801_1.0.28-1_all.deb** & **tuxedo-yt6801_1.0.30tux5_all.deb** & **net_check.sh** ins **/root** Verzeichnis kopieren.

Ausführbar machen:

**chmod a+x /root/yt6801-autoinstall.sh /root/net_check.sh**

**crontab -e** # Dies als root ausführen (sudo)!

Eintragen/hinzufügen im Cron:

        @reboot /root/yt6801-autoinstall.sh
        */15 * * * * /root/net_check.sh

Jetzt speichern.

Oder mit diesem Einzeiler (Du musst als root eingeloggt sein!):

        cd /root && git clone https://github.com/ltspicer/motorcomm-yt6801-autoinstall.git && cd motorcomm-yt6801-autoinstall && chmod a+x yt6801-autoinstall.sh net_check.sh && (crontab -l 2>/dev/null | grep -v -E 'yt6801-autoinstall.sh|net_check.sh'; echo "@reboot /root/motorcomm-yt6801-autoinstall/yt6801-autoinstall.sh"; echo "*/15 * * * * /root/motorcomm-yt6801-autoinstall/net_check.sh") | crontab -

**Unbedingt die Router/Gateway IP in beiden Scripten eintragen!**

---------------------------------------------

## Autoinstall of motorcomm-yt6801 driver after Kernel update

Since this driver is not automatically recognized by Linux, boot problems may occur.
Network connection is no longer possible.
For servers without a screen, such as Proxmox, this is quite annoying and time-consuming.
Since DKMS does not work reliably in this case either, I created an autoinstall script
that is called after a reboot.


Copy **yt6801-autoinstall.sh** & **tuxedo-yt6801_1.0.28-1_all.deb** & **tuxedo-yt6801_1.0.30tux5_all.deb** & **net_check.sh** to the **/root** directory.

Make executable:

**chmod a+x /root/yt6801-autoinstall.sh /root/net_check.sh**

**crontab -e** # Run this as root (sudo)!

Enter/add in Cron:

        @reboot /root/yt6801-autoinstall.sh
        */15 * * * * /root/net_check.sh

Save now.

Or with this one-liner (You must be logged in as root!):

        cd /root && git clone https://github.com/ltspicer/motorcomm-yt6801-autoinstall.git && cd motorcomm-yt6801-autoinstall && chmod a+x yt6801-autoinstall.sh net_check.sh && (crontab -l 2>/dev/null | grep -v -E 'yt6801-autoinstall.sh|net_check.sh'; echo "@reboot /root/motorcomm-yt6801-autoinstall/yt6801-autoinstall.sh"; echo "*/15 * * * * /root/motorcomm-yt6801-autoinstall/net_check.sh") | crontab -

**Be sure to enter the router/gateway IP address in both scripts!**
