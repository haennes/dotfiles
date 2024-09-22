{ pkgs, globals, ... }: ''
  DMENU="${globals.dmenu}"
  screenshot_dir="$HOME/.screenshots"  #TODO globals
  mkdir "$screenshot_dir"

  get_timestamp() {
      date '+%Y%m%d-%H%M%S'
  }

  case "$(echo -e 'Fullscreen\nActive screen\nSelected region' | $DMENU)" in
      "Fullscreen")
          targetCMD="screen"
          ;;
      "Active screen")
          targetCMD="output"
          ;;
      "Selected region")
          targetCMD="area"
          ;;
  esac

  if [ -z "$targetCMD" ]; then
      exit
  fi

  outputCMD=$(echo -e "save\ncopy\ncopysave" | $DMENU)

  if [ -z "$outputCMD" ]; then
      exit
  fi

  timer=$(echo -e "0\n1" | $DMENU -window-title "timer")
  if [ -z "$timer" ]; then
      exit
  fi

  sleep $timer
  grimblast --notify $outputCMD $targetCMD "$screenshot_dir/$(get_timestamp).png"
''

