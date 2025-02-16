{ ... }: {
  services.cliphist = {
    enable = true;

    systemdTargets = [ "hyprland-session.target" ];
  };
}
