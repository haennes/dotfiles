{ lib, osConfig, ... }: {

  config = lib.mkIf osConfig.programs.virt-manager.enable {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
