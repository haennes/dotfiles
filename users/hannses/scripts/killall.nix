{ pkgs, globals, ... }:
{
  killall = pkgs.pkgs.writeShellScript "killall" ''
    # has to be a function because "'...'" doesn't work
    DMENU() {
      ${globals.dmenu} -theme-str 'window { width: 75%; }' 
    }

    processes=$(ps axo user,comm | sed -n -e "s/$USER\s*//p" | sort | uniq)


    choice=$(echo "$processes" | DMENU)

    if [ -n "$choice" ]; then
        killall $choice
    fi
  '';
}
