{ lib, ... }:
rec {
  genNodeSimple = inputs: self: name: {
    ${name} = genNode inputs self.nixosConfigurations.${name} name;
  };
  genNode = inputs: machine: hostname: {
    inherit hostname;
    profiles.system = {
      user = "root";
      sshUser = "root";
      path = inputs.deploy-rs.lib.${machine.pkgs.system}.activate.nixos machine;
    };
  };

  mkDeploy =
    {
      inputs,
      self,
      exclude,
    }:
    #https://github.com/Yash-Garg/dotfiles/blob/stable/lib/deploy/default.nix
    let
      hosts = lib.removeAttrs (self.nixosConfigurations or { }) exclude;
      oneNodeSet =
        hostnameMapF:
        lib.mapAttrs' (
          _: machine:
          let
            mappedHostname = hostnameMapF machine.config.networking.hostName;
          in
          {
            name = mappedHostname;
            value = genNode inputs machine mappedHostname;
          }
        ) hosts;
      noports = str: "${str}_noports";
      l = str: "l_${str}";
      m = str: "m_${str}";
      g = str: "g_${str}";
      nodes =
        (oneNodeSet (str: l str))
        // (oneNodeSet (str: l (noports str)))
        // (oneNodeSet (str: m str))
        // (oneNodeSet (str: m (noports str)))
        // (oneNodeSet (str: g str))
        // (oneNodeSet (str: g (noports str)));
    in
    nodes;

}
