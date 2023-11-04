# Disable ALT+CTRL+BACKSPACE to Restart the X Display Manager

By default, several Linux distributions (including Debian 5.0 Lenny) enable the ALT+CTRL+BACKSPACE combination in the graphical environment (whether locked or not) to restart the X server.

This allows any user physically in front of the computer to initiate a graphical login, as it terminates (and kills) the processes of the user with the current active graphical session. To disable this function, you need to modify (or add) the ServerFlags section in the file **/etc/X11/xorg.conf**:

```conf
Section "ServerFlags"
  Option "DontZap"  "Yes"
EndSection

