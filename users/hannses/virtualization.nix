{lib, virt-manager_enable, ...}:{

  config = lib.mkIf virt-manager_enable {
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  };
}
