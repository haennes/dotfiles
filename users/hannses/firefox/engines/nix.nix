{ lib, favicon, pkgs, ... }:let
  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg" ;
in
lib.mapAttrs (_name: value: if value ? icon then value else value // {inherit icon;})
{
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

    definedAliases = [ "<nh" ];
  };
  "nixvim" = {
    urls = [{
      template =
        "https://nix-community.github.io/nixvim/plugins/nix.html?search={searchTerms}";
    }];

    definedAliases = [ "<nixvim" ];
  };
  "github nixpkgs" = {
    urls = [{
      template =
        "https://github.com/search?q=repo%3ANixOS%2Fnixpkgs+{searchTerms}&type=code";
    }];

    definedAliases = [ "<npkgs" "<ghnpgks" "<ghnp" ];
  };
  "NixOS Wiki" = {
    urls =
      [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];

    definedAliases = [ "<nw" ];
  };

  "Home Manager Option Search" = {
    urls = [{
      template =
        "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
    }];

    definedAliases = [ "<ho" ];
  };
}
