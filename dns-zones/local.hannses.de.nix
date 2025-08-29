{ inputs, config, ... }:
with inputs.dns.lib.combinators;
let
  ips = config.ips.ips.ips.default;
  zone = "local.hannses.de.";
  serial = 2025011701;

  /* *
     Creates a CNAME record
  */
  mkCname = target: { CNAME = [ target ]; };

  nameserver = "ns.hannses.de";
in {
  TTL = 1800; # 30 minutes

  SOA = {
    nameServer = nameserver;
    adminEmail = "1nkolr58@anonaddy.me";
    inherit serial;
  };

  NS = [ nameserver ];

  CAA = letsEncrypt config.security.acme.defaults.email;

  subdomains = {
    # nameserver:
    ns = mkCname "ns.hannses.de";

    # hosts:
    anki = host ips.minerva.wg0 null;
    hydra = host ips.welt.wg0 null;
    nix-serve = host ips.welt.wg0 null;
    task = host ips.dea.wg0 null;
    rss = host  ips.fons.wg0 null;
    zock = host "172.20.0.41" null;
    ftb = host ips.ludus.wg1 null;
  };
}
