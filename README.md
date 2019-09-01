# AutoRecording
Bash script to automatically start recording on a Raspberry Pi using a flatmax's Octo Channel Sound Card

Create Folder TestDirection on home and add file checkMics.sh to it

Add tne next line on: /home/pi/.config/lxsession/LXDE-pi/autostart

Or on: /etc/xdg/lxsession/LXDE-pi/autostart 

```
@lxterminal -e sudo ./TestDirection/checkMics.sh
```
