{ pkgs, globals, ... }: ''
  # has to be a function because "'...'" doesn't work
  DMENU() {
    ${globals.dmenu} -theme-str 'window { width: 75%; }'
  }

  processes=$(ps axo user,pid,args | sed -n -e "s/$USER\s*//p")

  choice=$(echo -e "$processes" | DMENU)

  if [ -n "$choice" ]; then
      kill -9 $(echo -e "$choice" | awk -e '{print $1}')
  fi
''

