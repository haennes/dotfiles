{ lib, inputs, ... }: rec {
  wireguard = import ./wireguard.nix;
  systemd_timer_service = import ./systemd_timer_service.nix;

  ip_cidr = ip: "${ip}/32";
  __subnet = ip:
    (builtins.concatStringsSep "."
      (lib.lists.take 3 (lib.strings.splitString "." ip)));
  subnet_cidr = ip: let subnet = (__subnet ip); in "${subnet}.0/24";

  public_ip_ranges =
    [ # this gets suggested on wireguard android as soon as you type in 0.0.0.0/0
      "0.0.0.0/5"
      "8.0.0.0/7"
      "11.0.0.0/8"
      "12.0.0.0/6"
      "16.0.0.0/4"
      "32.0.0.0/3"
      "64.0.0.0/2"
      "128.0.0.0/3"
      "160.0.0.0/5"
      "168.0.0.0/6"
      "172.0.0.0/12"
      "172.32.0.0/11"
      "172.64.0.0/10"
      "172.128.0.0/9"
      "173.0.0.0/8"
      "174.0.0.0/7"
      "176.0.0.0/4"
      "192.0.0.0/9"
      "192.128.0.0/11"
      "192.160.0.0/13"
      "192.169.0.0/16"
      "192.170.0.0/15"
      "192.172.0.0/14"
      "192.176.0.0/12"
      "192.192.0.0/10"
      "193.0.0.0/8"
      "194.0.0.0/7"
      "196.0.0.0/6"
      "200.0.0.0/5"
      "208.0.0.0/4"
      "1.1.1.1/32"
    ];

  age_obtain_user_password = username: config: {
    age.secrets.${"${username}"} = {
      file = ../secrets/user_passwords/${username}.age;
      owner = "root";
      group = "root";
    };
  };
  get_key_string_unsafe = { secret_name }:
    {
      #age.secrets.${secret_name}
    };

  recursiveMerge = listOfAttrsets:
    lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) { } listOfAttrsets;

  genNodeSimple = self: name: {
    ${name} = genNode self.nixosConfigurations.${name} name;
  };
  genNode = machine: hostname: {
    inherit hostname;
    profiles.system = {
      user = "root";
      sshUser = "root";
      path = inputs.deploy-rs.lib.${machine.pkgs.system}.activate.nixos machine;
    };
  };

  mkDeploy = { self, exclude }:
    #https://github.com/Yash-Garg/dotfiles/blob/stable/lib/deploy/default.nix
    let
      hosts = lib.removeAttrs (self.nixosConfigurations or { }) exclude;
      oneNodeSet = hostnameMapF:
        lib.mapAttrs' (_: machine:
          let mappedHostname = hostnameMapF machine.config.networking.hostName;
          in {
            name = mappedHostname;
            value = genNode machine mappedHostname;
          }) hosts;
      noports = str: "${str}_noports";
      l = str: "l_${str}";
      m = str: "m_${str}";
      g = str: "g_${str}";
      nodes = (oneNodeSet (str: l str)) // (oneNodeSet (str: l (noports str)))
        // (oneNodeSet (str: m str)) // (oneNodeSet (str: m (noports str)))
        // (oneNodeSet (str: g str)) // (oneNodeSet (str: g (noports str)));
    in nodes;
}
