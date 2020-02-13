yum groupinstall -y 'gnome desktop'
yum install -y 'xorg*'
yum remove -y initial-setup initial-setup-gui
systemctl isolate graphical.target
systemctl set-default graphical.target 
yum install kbd
loadkeys ua
loadkeys us 
