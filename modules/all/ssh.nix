{ config, ... }: {
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true; # TODO: extract into module
    ports = [ config.ports.ports.curr_ports.sshd ];
  };
}

