{ scripts, globals, ... }: ''
    DMENU="${globals.dmenu}"
    startingDir="$HOME/.wallpapers"

    # If you want to use this for your own setup you will probably have to change the switchWallpaper function as well as the monitors=... call.
    # I have provided some options in this file.
    # A complete X11 configuration using feh can currently be found on my github: https://github.com/jalupaja/jalupa_config/blob/master/dmenuscripts/changeBackground


  # This will save the current call with all arguments to the given path so that you can use it on startup
  CALLSAVEPATH="$HOME/.wallpapercall"
  # CALLSAVEPATH=/dev/null # if you dont want this functionality

  # get the current file location
  # this is used to find the needded file_selector.sh
  if [ "''${0::1}" = "/" ]; then
      shFile=$0
  else
      shFile="$(pwd)/$0"
  fi
  # build call structure to make it reproduceable
  callStr="$shFile"

  # make options accessible from cli
  while getopts "r:m:t:p:h" args; do
      case "''${args}" in
          r)
              case "''${OPTARG}" in
                  1)
                      selectedRan="random repeat"
                      ;;
                  2)
                      selectedRan="random once"
                      ;;
                  3)
                      selectedRan="select once"
                      ;;
                      # will use dmenu as a fallback
              esac
              ;;
          m)
              case "''${OPTARG}" in
                  1)
                      selectedMon="per monitor"
                      ;;
                  2)
                      selectedMon="single monitor"
                      ;;
                      # will use dmenu as a fallback
              esac
              ;;
          t)
              selectedTime=''${OPTARG}
              ;;
          p)
              path=''${OPTARG}
              ;;
          h)
              echo "\
                -r | select random mode: 1=random repeat, 2=random once, 3=select once
                -m | select monitor mode: 1=per monitor, 2=on all monitors
                -t | input the time needed for random repeat
                -p | select the full file or directory path to either the image or the directory from wich to randomly choose images \
                "
              exit
              ;;
          *)
              # wrong option
              exit
              ;;
        esac
      done

  if [ -z "$selectedRan" ]; then
  choice="random repeat\nrandom once\nselect once"
    selectedRan=$(echo -e $choice | $DMENU)

    if [ -z "$selectedRan" ]; then
      exit
    fi
  fi

  function updateMonitor {
    # different options to get current monitors
    monitors=($(swww query | awk '{print substr($1, 1, length($1) - 1)}'))
    # monitors=($(hyprctl monitors | grep "Monitor" | awk '{print $2}'))
    # for X11
    # monitors=($(xrandr --listactivemonitors | tail -n +2 | awk '{print $4}'))
  }

  updateMonitor

  if [ -z "$selectedMon" ]; then
      if [[ ''${#monitors[@]} > 1 ]]; then
          choice="per monitor\nsingle monitor"
          selectedMon=$(echo -e $choice | $DMENU)

          if [ -z "$selectedRan" ]; then
              exit
          fi
      fi
  fi

  if [ -z "$path" ]; then
      if [ "$selectedRan" = "select once" ]; then
          # select file
          path=$(${scripts.file_selector} -p "$startingDir")
      else
          # select path
          path=$(${scripts.file_selector} -d -p "$startingDir")
      fi

      if [ -z "$path" ]; then
          exit
      fi
  fi

  function switchWallpaper {
      # $1:  full path to wallpaper
      # $2: monitor [optional]
      if [ -n "$2" ]; then
          # single monitor
          swww img --outputs "$2" --transition-type "fade" "$1"
      else
          # all monitors
          swww img --transition-type "fade" "$1"
      fi
  }

  function ranFromDir {
      file="$(fd . $1 | grep -v -E '/$' | shuf -n 1)"
  }

  # kill old script if any are running
  script_name=$(echo "$0" | sed 's/.*\///g')
  id=($(ps aux | grep "/$script_name" | awk '{print $2}'))
  first_id=''${id[0]}
  # dont kill process if it is the current process
  if [ "$first_id" != "$$" ]; then
      kill $first_id
  fi

  if [ "$selectedRan" = "select once" ]; then
      # build call structure to make it reproduceable
      callStr="$callStr -r 3 -m 2 -p $path"
      echo "$callStr" > $CALLSAVEPATH

      switchWallpaper "$path"
  elif [ "$selectedRan" = "random once" ]; then
      ## random from directory
      ranFromDir $path
      if [ "$selectedMon" = "single monitor" ]; then
          # build call structure to make it reproduceable
          callStr="$callStr -r 2 -m 2 -p $path"
          echo "$callStr" > $CALLSAVEPATH

          # both monitors
          switchWallpaper "$path/$file"
      else
          # build call structure to make it reproduceable
          callStr="$callStr -r 2 -m 1 -p $path"
          echo "$callStr" > $CALLSAVEPATH

          # per monitor
          for i in ''${monitors[@]};
          do
              # Random in directory
              switchWallpaper "$path/$file" "$i"
          done
      fi
  elif [ "$selectedRan" = "random repeat" ]; then
      if [ -z "$selectedTime" ]; then
          selectedTime=$(($(echo "every ... seconds" | $DMENU)))

          if [ -z "$selectedRan" ]; then
              exit
          fi
      fi
      if [[ $selectedTime < 1 ]]; then
          selectedTime=1800
      fi

      # build call structure to make it reproduceable
      if [ "$selectedMon" = "per monitor" ]; then
          callStr="$callStr -r 1 -m 1 -t $selectedTime -p $path"
      else
          callStr="$callStr -r 1 -m 2 -t $selectedTime -p $path"
      fi
      echo "$callStr" > $CALLSAVEPATH

      while true;
      do
          ## random from directory
          ranFromDir $path
          if [ "$selectedMon" = "per monitor" ]; then
              # per monitor
              updateMonitor
              for i in ''${monitors[@]};
              do
                  # Random in directory
                  switchWallpaper "$file" "$i"
                  ranFromDir $path
              done
          else
              # both monitors
              switchWallpaper "$file"
          fi
          sleep $selectedTime
      done
  fi
''
