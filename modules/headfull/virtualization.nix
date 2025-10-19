{ pkgs, lib, config, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  virtualisation.docker.enable = true;

  # dont build virtualbox
  virtualisation.virtualbox.host.enable = true;

  users.extraGroups = lib.mkIf config.virtualisation.virtualbox.host.enable {
    vboxusers.members = [ "hannses" ];
  };
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  virtualisation.waydroid.enable = true;
  systemd.services.waydroid-container.wantedBy = lib.mkForce [ ];

  programs.virt-manager.enable = true;

}
