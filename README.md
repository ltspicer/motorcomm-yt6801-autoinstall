# motorcomm-yt6801-autoinstall
## Autoinstall of motorcomm-yt6801 driver after Kernel update

Da dieser Treiber nicht automatisch von Linux erkannt wird, können Bootprobleme entstehn.
Es ist keine Netzwerk verbindung mehr möglich.
Bei Servern ohne Bildschirm wie zBsp. bei Proxmox ist das ziemlich ärgerlich und aufwändig.
Da DKMS in diesem Fall auch nicht zuverlässig funktioniert, habe ich ein autoinstall Script erstellt,
welches nach einem Reboot aufgerufen wird.


**yt6801-autoinstall.sh** & **tuxedo-yt6801_1.0.28-1_all.deb** ins **/root** Verzeichnis kopieren.

Ausführbar machen:

**chmod a+x /root/yt6801-autoinstall.sh**

**crontab -e** # Dies als root ausführen!

Eintragen/hinzufügen:

**@reboot /root/yt6801-autoinstall.sh**

Jetzt speichern.

**Unbedingt die Router/Gateway IP im Script eintragen!**

----------------------------------------------------------------------

Since this driver is not automatically recognized by Linux, boot problems may occur.
Network connection is no longer possible.
For servers without a screen, such as Proxmox, this is quite annoying and time-consuming.
Since DKMS does not work reliably in this case either, I created an autoinstall script
that is called after a reboot.


Copy **yt6801-autoinstall.sh** & **tuxedo-yt6801_1.0.28-1_all.deb** to the **/root** directory.

Make executable:

**chmod a+x /root/yt6801-autoinstall.sh**

**crontab -e** # Run this as root!

Enter/add:

**@reboot /root/yt6801-autoinstall.sh**

Save now.

**Be sure to enter the router/gateway IP in the script!**
