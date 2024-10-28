{ pkgs, globals, ... }: ''
  DMENU="${globals.dmenu}"
  getopts "mue" flag
  case "''${flag}" in
      e) # eject
  	to_ejec=$(lsblk -e 7 -o TYPE,NAME,SIZE,MOUNTPOINTS -l | tail -n +2 | sed -n '/^.*[0-9]. *$/p' | sed -n '/^disk\s*/p' | awk '{print $2 " " $3}' | column -t | $DMENU " mount ")
  	if [ -n "$to_ejec" ];
  	then
  	    ${pkgs.udisks}/bin/udisksctl power-off -b /dev/"$(echo -e $to_ejec | awk '{print $1}')"
  	fi
  	if [ $? -ne 0 ];
  	then
  	    ${pkgs.libnotify}/bin/notify-send -a "umount" "Ejecting failed!"
  	fi
  	;;
      u) # umount
  	to_umnt=$(lsblk -e 7 -o TYPE,NAME,SIZE,MOUNTPOINTS -l | tail -n +2 | sed '/^.*[0-9]. *$/d' | sed -n '/^part\s*/p' | awk '{print $2 " " $4 " " $3}' | column -t | $DMENU " umount ")
  	if [ -n "$to_umnt" ];
  	then
  	    ${pkgs.udisks}/bin/udisksctl unmount -b /dev/"$(echo -e $to_umnt | awk '{print $1}')"
  	fi
  	if [ $? -ne 0 ];
  	then
  	    ${pkgs.libnotify}/bin/notify-send -a "umount" "Unmounting failed!"
  	fi
  	;;
      m | *) # default is mount
  	to_mnt=$(lsblk -e 7 -o TYPE,NAME,SIZE,MOUNTPOINTS -l | tail -n +2 | sed -n '/^.*[0-9]. *$/p' | sed -n '/^part\s*/p' | awk '{print $2 " " $3}' | column -t | $DMENU " mount ")
  	if [ -n "$to_mnt" ];
  	then
  	    ${pkgs.udisks}/bin/udisksctl mount -b /dev/"$(echo -e $to_mnt | awk '{print $1}')"
  	fi
  	if [ $? -ne 0 ];
  	then
  	    ${pkgs.libnotify}/bin/notify-send -a "mount" "Mounting failed!"
  	fi
  	;;
  esac
''
