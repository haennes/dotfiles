{ pkgs, globals, ... }:
{
  brightness = pkgs.pkgs.writeShellScript "brightness" ''
    # the user has to be inside of the "video" group to not need sudo!

    DMENU="${globals.dmenu}"

    levels="0
    5
    20
    60
    99"

    step=$(($(cat /sys/class/backlight/intel_backlight/max_brightness) / 100))
    current=$(($(cat /sys/class/backlight/intel_backlight/brightness) / $step))

    end () {
        if [ -n "$value" ]; then
            if [ "$value" -le "100" ]; then
                echo $(($value * $step)) > /sys/class/backlight/intel_backlight/brightness
            fi
            notify-send -a "brightness" "set brightness to $value"
        fi
        exit 0
    }

    getopts "ids:" flag
    case "''${flag}" in
        i) 
            if [ "$current" -eq "0" ]; then
                value=1
            elif [ "$current" -eq "1" ]; then
                value=5
            elif [ "$(($current + 5))" -gt "100" ]; then
                value=100
            else
                value=$(($current + 5))
            fi
            end
            ;;
        d)
            if [ "$current" -eq "1" ]; then
                value=0
            elif [ "$(($current - 5))" -lt "1" ]; then
                value=1
            else
                value=$(($current - 5))
            fi
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
  '';
}
