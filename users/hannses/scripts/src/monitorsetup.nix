{ globals, ... }: ''
  DMENU="${globals.dmenu}"

  # hyprctl dispatch dpms off (disable monitor power off temporarily)
  # hyprctl keyword monitor 'monitor,redsolution,position,scale[,transform,1]'
  # transform -> rotate
  #hyprctl keyword monitor 'DP-7,preferred,0x0,1,transform,1'

  monitors=($(wlr-randr | grep '^\S' | awk '{print $1}'))

  monitor_index=$(wlr-randr | grep -E "Make|Model" | sed 's/.*: //' |  sed 'N;s/\n/ /g' | $DMENU -format 'i')

  if [ -z $monitor_index ]; then
      exit
  fi

  DMENU="$DMENU -window-title"

  monitor="''${monitors[monitor_index]}"
  settings=$(wlr-randr | sed -n -e "/$monitor/,/^\S/ p")
  hyprsettings=$(hyprctl monitors | sed -n -e "/$monitor/,/^$/ p")
  resolutions=$(echo "preferred\nhighres\nhighrr\n$(echo "$settings" | grep '\s\s\s\s' | awk '{print $1 "@" $3}')")
  mirror="off"

  # TODO get current values
  resolution="$(echo "$hyprsettings" | sed -n 2p | awk '{print $1}')"
  #position="$(echo "$hyprsettings" | sed -n 2p | awk '{print $3}')"
  position="auto"
  scale="$(echo "$hyprsettings" | grep -i "scale" | awk '{print $2}')"
  rotation=$((($(echo "$hyprsettings" | grep -i "transform" | awk '{print $2}') * 90)))

  if [ $(echo "$settings" | grep "Enabled" | awk '{print $2}') = "yes" ]; then
      enabled="on"
  else
      enabled="off"
  fi

  while true; do
      option=$(echo -e "resolution: $resolution\nscale: $scale\nmirror: $mirror\nrotation: $rotation\nenabled: $enabled\nsave" | $DMENU "$monitor")

      if [ -z "$option" ]; then
          break
      fi

      case $(echo "$option" | sed 's/:.*//') in
          "resolution")
              tmp=$(echo -e "$resolutions" | $DMENU)
              if [ -n "$tmp" ]; then
                  resolution="$tmp"
              fi
              ;;
          "position")
              if [ ''${#monitors[@]} > 2 ]; then
                  pos="$(echo -e "auto\nabove\nleft of\nbelow\nright of" | $DMENU)"
                  if [ -z "$pos" ]; then
                      tmp=""
                  elif [[ "$pos" = "auto" ]]; then
                      tmp="auto"
                  else
                      pos_to=$(echo "''${monitors[@]/$monitor}" | tr ' ' '\n' | $DMENU "$pos")
                      if [ -z "$pos_to" ]; then
                          tmp=""
                      else
                          # TODO dont use todo: use actual words, test not auto
                          tmp="todo"
                      fi
                  fi

                  if [ -n "$tmp" ]; then
                      position="$tmp"
                  fi
              fi
              ;;
          "scale")
              tmp=$(echo -e "auto\n1\n1.25\n1.5" | $DMENU)
              if [ -n "$tmp" ]; then
                  scale="$tmp"
              fi
              ;;
          "rotation")
              tmp=$(echo -e "0\n90\n180\n270" | $DMENU)
              if [ -n "$tmp" ]; then
                  rotation="$tmp"
              fi
              ;;
          "mirror")
              tmp=$(echo -e "off\n''${monitors[@]/$monitor}" | tr ' ' '\n' | $DMENU)
              if [ -n "$tmp" ]; then
                  mirror="$tmp"
              fi
              ;;
          "enabled")
              if [ $(echo "$option" | awk '{print $2}') = "on" ]; then
                  hyprctl keyword monitor "$monitor,disable"
              fi
              exit
              ;;
          "save")
              # re-translate back
              rotation=$((($rotation/90)))
              if [[ "$mirror" = "off" ]]; then
                  mirror=""
              else
                  mirror=",mirror,$mirror"
              fi

              if [[ "$position" = "todo" ]]; then
                  position="10000x10000"
              fi

              hyprctl keyword monitor "$monitor,$resolution,$position,$scale,transform,$rotation$mirror"
              exit
              ;;
      esac
  done
''

