{ ... }: {
  ips.ips.default = {
    "192.168" = {
      #local wohnheim
      "0" = {
        #this is dumb!!! I actually have DHCP configured determine which is better...
        "13" = "pve%vmbr0";
        "15" = "porta%ens3";
        "23" = "syncschlawiner%ens3";
        "27" = "syncschlawiner_mkhh%ens3";
        "25" = "tabula%ens3";
        "26" = "grapheum%ens3";
      };

      #vpn endpoints
      #commit to naming scheme:
      # - 0xx for servers
      # - 1(0-4)x for workstations
      # - 1(5-9)x mobiles
      # - 2xx for reserved
      "1" = {
        "3" = "welt%wg0";
        "4" = "porta%wg0";
        "5" = "syncschlawiner%wg0";
        "6" = "thinkpad%wg0";
        "7" = "handy_hannses%wg0";
        "8" = "tabula%wg0";
        "9" = "syncschlawiner_mkhh%wg0";
        "10" = "deus%wg0";
        "11" = "hermes%wg0";
        "12" = "historia%wg0";
        "13" = "fons%wg0";
        "14" = "minerva%wg0";
        "16" = "thinknew%wg0";
        "17" = "yoga%wg0";
      };

      "3" = {
        #vm subnet
        # naming scheme:
        # 1-9  - internal
        "2" = "vm-host%br0";

        # others - any vm
        "11" = "vm-tabula%br0";
        "12" = "vm-fons%br0";
        "13" = "vm-historia%br0";
        "14" = "vm-minerva%br0";
      };

    };

    "57.129.6.13" = "welt%ens3"; # DO NOT USE THIS USE THE DOMAIN INSTEAD
  };
}

#{
#  pve = { vmbr0 = "192.168.0.13"; };
#  welt = {
#    ens3 = "57.129.6.13";
#    wg0 = "192.168.1.3";
#  };
#  porta = {
#    ens18 = "192.168.0.15";
#    wg0 = "192.168.1.4";
#  };
#  hermes.wg0 = "192.168.1.11";
#  syncschlawiner = {
#    wg0 = "192.168.1.5";
#    ens0 = "192.168.0.23";
#  };
#  syncschlawiner_mkhh = {
#    wg0 = "192.168.1.9";
#    ens0 = "192.168.0.27";
#  };
#  thinkpad.wg0 = "192.168.1.6";
#  thinknew.wg0 = "192.168.1.16";
#  yoga.wg0 = "192.168.1.17";
#  mainpc.wg0 = "192.168.1.10";
#  handy_hannses.wg0 = "192.168.1.7";
#  tabula = {
#    wg0 = "192.168.1.8";
#    ens0 = "192.168.0.25";
#  };
#  grapheum = { ens0 = "192.168.0.26"; };
#}
