{ osConfig, ... }:
let ips = osConfig.ips.ips.ips.default;
in {

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = true;
      sync_frequency =
        "5m"; # FIXME sync less when on mobile data to avoid unneccesarry data usage
      sync_address = "http://${ips.historia.wg0}:${
          toString osConfig.ports.ports.ports.historia.atuin
        }";
      keymap_mode = "vim-normal";
    };
  };
}
