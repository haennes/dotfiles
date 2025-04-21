{ inputs, ... }: {
  imports = [ inputs.simple-nixos-mailserver.nixosModules.default ];
  age.secrets = {
    demo-mail.file = ../../../secrets/demo-pw.age
  };

  mailserver = {
    enable = true;
    fqdn = "mail.mkhh.hannses.de";
    useUTF8FolderNames = true;

    dmarcReporting = {
      enable = true;
      domain = "mkhh.hannses.de";
      organizationName = "MKHH";
    };

    domains = ["mkhh.hannses.de"];
    fullTextSearch =  {
      enable = true;
      autoIndex = true;
      enforced = "body";
    };
    enableManageSieve = true;

    # monitoring = { };
    localDnsResolver = false;

    loginAccounts = {
      "demo@mkhh.hannses.de" =
    };
  };
}
