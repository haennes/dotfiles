{ globals, config, ... }: ''
    # has to be a function because "'...'" doesn't work
    DMENU() {
      ${globals.dmenu} -theme-str 'window { width: 75%; }' -window-title "$1"
    }

    # This script is copied from https://github.com/GeorgiChalakov01/wifi-control
    # and has been edited to work for me

    case $(echo -e "CONNECT\nDISCONNECT\nHOTSPOT\nWIFI ON\nWIFI OFF" | DMENU "WIFI Options: ";) in
        CONNECT)
            wifiname=$(nmcli d wifi list | DMENU "Select WIFI" | cut -d' ' -f9);
            if [ -n "$wifiname" ]; then
                nmcli d wifi connect $wifiname
            fi

            sleep 5
            wget -q --spider https://duckduckgo.com
            if [ $? -eq 0 ]; then
                notify-send -a wifi "wifi activated!"
            else
                notify-send -a wifi "connection failed!"
            fi
            ;;
        DISCONNECT)
            internet=$(nmcli | grep "connected" | sed -n '1p' | cut -c 22-);
            nmcli con down id $internet;
            ;;
        "HOTSPOT")
  	    if [ $(nmcli con | awk '{print $1}' | grep '^Hotspot$' | wc -w) -le 0 ]; then
  	    	nmcli con add type wifi ifname wlp0s20f3 con-name Hotspot autoconnect no ssid Hotspot
  	    fi
  	    nmcli con modify Hotspot 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared
  	    nmcli con modify Hotspot wifi-sec.key-mgmt wpa-psk
  	    nmcli con modify Hotspot wifi-sec.psk $(cat ${
         config.age.secrets."wifihotspot.age".path
       })
  	    nmcli con up Hotspot
  	    ;;
        "WIFI ON")
            nmcli radio wifi on;
            ;;
        "WIFI OFF")
            nmcli radio wifi off;
            ;;
        *)
            echo "idk what happend. terminating..." && exit 0
            ;;
    esac
''

