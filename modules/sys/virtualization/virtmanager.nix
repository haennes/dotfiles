{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.virtualization.virtmanager.enable = mkEnableOption "virtmanager" // {
    default = config.is_client;
  };
  config = mkIf config.my.virtualization.virtmanager.enable {
    services.spice-vdagentd.enable = true;
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    services.qemuGuest.enable = true;

    programs.virt-manager.enable = true;
  };
}
