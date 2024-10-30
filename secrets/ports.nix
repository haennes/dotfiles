{ lib, ... }:
let
  common = {
    "51821" =
      "wg0"; # not all run wireguard, but never use port for sth different
    "5432" =
      "postgresql"; # default postgres port, just to make sure not bound again
    "8384" =
      "syncthing.gui"; # not all run syncthing, but never use port for sth different
    "22" = "sshd";
  };
  headfull = {
    "8385" = "ssh.syncschlawiner.syncthing.gui";
    "8386" = "ssh.syncschlawiner.nextcloud.web";
    "8006" = "ssh.proxmox.gui";
    "8388" = "ssh.tabula.syncthing.gui";
    "8390" = "ssh.tabula.web";
    "9090" = "ssh.syncschlawiner.ipfs.api";
    "9091" = "ssh.syncschlawiner.ipfs.gateway";

    "9081" = "tasks.uni";
    "9082" = "tasks.haushalt";
    "9083" = "tasks.projekte";
    "9084" = "tasks.coding";

    "8088" = "homepage-dashboard";
    "8082" = "rss";
    "8384" = "syncthing.gui";

    "20002" = "autossh-monitoring.syncschlawiner";
    "20000" = "autossh-monitoring.pve";
  };
  #do note that value takes precedence
in {
  ports.ports = lib.mapAttrs' (name: value: {
    inherit name;
    value = (common // value);
  }) {
    # could also be ${config.syncthing}
    yoga = headfull;
    thinkpad = headfull;
    thinknew = headfull;
    mainpc = headfull;

    syncschlawiner = {
      "8081" = "ipfs.api";
      "8080" = "ipfs.gateway";
      "80" = "nextcloud.web";
      "8001" = "kasmweb.gui";
      "8384" = "syncthing.gui";
    };
    syncschlawiner_mkhh = { };
    tabula = { "80" = "web"; };
    porta = { };
    welt = { };
    fons = { };
    deus = {
      "3000" = "hydra";
    };
    historia = { "8888" = "atuin"; };

    #scheme:
    #hostname.port = "service"
    #decided to not encourage allow hostname.digit.rest = "service" as it gets to confusing
  };
}

