{ pkgs, ... }: {
  programs.wireshark = {
    dumpcap.enable = true;
    enable = true;
    usbmon.enable = true;
  };
  environment.systemPackages = with pkgs; [ wireshark ];
  users.users.hannses.extraGroups = [ "wireshark" ];

}
