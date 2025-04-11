{ config, lib, ... }:
let inherit (config.ports.ports) curr_ports;
in {
  #if a more complex setup is needed use: https://github.com/Infinidoge/nix-minecraft
  services.minecraft-server = lib.mkIf config.services.minecraft-server.enable {
    #enable = true;
    eula =
      true; # set to true if you agree to Mojang's EULA: https://account.mojang.com/documents/minecraft_eula
    declarative = true;

    # see here for more info: https://minecraft.gamepedia.com/Server.properties#server.properties
    serverProperties = {
      server-port = curr_ports.minecraft;
      gamemode = "survival";
      motd = "hannes ist alt xD";
      max-players = 5;
      enable-rcon = true;
      online-mode = false;
      # This password can be used to administer your minecraft server.
      # Exact details as to how will be explained later. If you want
      # you can replace this with another password.
      "rcon.password" = import ../../secrets/not_so_secret/minecraft/mc_geb.nix;
      level-seed = "10292992";
    };
  };

}
