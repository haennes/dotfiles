{ pkgs, globals, ... }:''
    # the user has to be inside of the "video" group to not need sudo!

    DMENU="${globals.dmenu}"

    levels="+5
    5-
    5
    20
    60
    99"

    end () {
        if [ -n "$value" ]; then
            ${pkgs.brightnessctl}/bin/brightnessctl  s $value%
            current=$(${pkgs.brightnessctl}/bin/brightnessctl -m  | grep -o '[^,]\+' | sed -n '4p')
            notify-send -a "brightness" "set brightness to $current"
        fi
        exit 0
    }

    getopts "ids:" flag
    case "''${flag}" in
        i)
            value="+5"
            end
            ;;
        d)
            value="5-"
            end
            ;;
        s)
            if [ -n "$OPTARG" ]; then
                value=$OPTARG
                end
            fi
            exit 1
            ;;
        :)
            value=$(echo "$levels" | $DMENU " $current ")
            end
            ;;
    esac

    value=$(echo "$levels" | $DMENU " $current ")
    end
  ''

