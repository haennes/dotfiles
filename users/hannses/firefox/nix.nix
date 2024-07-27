{ favicon, pkgs, ... }:let
  nix_favicon = favicon "search.nixos.org";
in{
  "Nix Packages" = {
    urls = [{
      template = "https://search.nixos.org/packages";
      params = [
        {
          name = "type";
          value = "packages";
        }
        {
          name = "query";
          value = "{searchTerms}";
        }
        {
          name = "channel";
          value = "unstable";
        }
      ];
    }];
    icon =
      "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "<np" ];
  };

  "Nix Options" = {
    urls = [{
      template = "https://search.nixos.org/options";
      params = [
        {
          name = "type";
          value = "packages";
        }
        {
          name = "query";
          value = "{searchTerms}";
        }
        {
          name = "channel";
          value = "unstable";
        }
      ];
    }];
    icon =
      "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "<no" ];
  };

  "Nix noogle" = {
    urls = [{
      template = "https://noogle.dev/";
      params = [{
        name = "term";
        value = "{searchTerms}";
      }];
    }];
    icon =
      "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "<nop" ];
  };

  "Nix Hound" = {
    urls = [{
      template = "https://search.nix.gsc.io/";
      params = [{
        name = "q";
        value = "{searchTerms}";
      }];
    }];
    icon =
      "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "<nh" ];
  };
  "nixvim" = {
    urls = [{
      template =
        "https://nix-community.github.io/nixvim/plugins/nix.html?search={searchTerms}";
    }];
    icon =
      "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "<nixvim" ];
  };
  "github nixpkgs" = {
    urls = [{
      template =
        "https://github.com/search?q=repo%3ANixOS%2Fnixpkgs+{searchTerms}&type=code";
    }];
    icon =
      "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "<npkgs" "<ghnpgks" "<ghnp" ];
  };
  "NixOS Wiki" = {
    urls =
      [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
    #iconUpdateURL = nix_favicon;
    #inherit updateInterval;
    icon =
      "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

    definedAliases = [ "<nw" ];
  };

  "Home Manager Option Search" = {
    urls = [{
      template =
        "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
    }];
    #iconUpdateURL = nix_favicon;
    #inherit updateInterval;
    icon =
      "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

    definedAliases = [ "<ho" ];
  };
}
