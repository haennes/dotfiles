{ ... }: {
  virtualisation.libvirtd.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  programs.virt-manager.enable = true; # };
}
