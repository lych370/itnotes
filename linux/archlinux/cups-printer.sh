#!/bin/sh
pacman -S cups ghostscript gsfonts cups-pdf gutenprint --noconfirm
sudo systemctl start org.cups.cupsd.service
sudo -S usermod -aG cups `whoami`
newgrp cups


echo "it will open default browser and visit printer network service.
login user is root.
"

xdg-open 'http://localhost:631'
