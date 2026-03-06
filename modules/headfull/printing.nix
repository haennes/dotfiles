{
  pkgs,
  config,
  lib,
  ...
}:
let
  hostnames = [
    "cups.localhost"
    "print.localhost"
  ];
in
{
  services.printing = {
    drivers = [
      pkgs.gutenprint
      pkgs.hplip
      pkgs.canon-cups-ufr2
    ];
    allowFrom = hostnames;
    enable = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.nginx.virtualHosts =
    let
      inherit (lib) map listToAttrs;
      mapListToAttrs = f: list: listToAttrs (map f list);
    in
    lib.mkIf config.services.nginx.enable (
      mapListToAttrs (d: {
        name = d;
        value = {
          locations."/" = {
            proxyPass = "https://${lib.head config.services.printing.listenAddresses}";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Accept-Encoding "";
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection 'upgrade';
              proxy_set_header Host '127.0.0.1';
              proxy_cache_bypass $http_upgrade;
              proxy_set_header X-Real-IP $remote_addr;
            '';
            recommendedProxySettings = false;
          };
        };
      }) hostnames
    );
  systemd.services."copy-printers" = {
    before = [ "cups.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      cp -v ${./printers}/printers.conf /etc/cups/printers.conf
      cp -av ${./printers}/ppd /etc/cups/
      chown root:lp /etc/cups/printers.conf
      chmod 0600 /etc/cups/printers.conf
      chown -R root:lp /etc/cups/ppd
      chmod 0644 /etc/cups/ppd/*
    '';
  };
  systemd.services.cups.partOf = [ "copy-printers.service" ];
}
