{ pkgs, addons, ... }:
let
  favicon = domain: "https://${domain}/favicon.ico"; # TODO use this instead
  nix_favicon = favicon "search.nixos.org";
  updateInterval = 24 * 60 * 60 * 1000; # every day
  gh_search = { type, alias, personal ? false, addAliases ? [ ], ... }:
    let title = "GitHub ${type}" + (if personal then " personal" else "");
    in {
      "${title}" = {
        urls = [{
          template = "https://github.com/search";
          params = [
            {
              name = "q";
              value = if personal then
                "owner:haennes+{searchTerms}"
              else
                "" + "{searchTerms}";
            }
            {
              name = "type";
              value = type;
            }
          ];
        }];
        definedAliases =
          [ ("<gh" + (if personal then "p" else "") + "${alias}") ]
          ++ addAliases;
        iconUpdateURL =
          "https://github.githubassets.com/assets/pinned-octocat-093da3e6fa40.svg";
        inherit updateInterval;
      };
    };
in {
  programs.firefox.enable = true;
  programs.firefox.profiles.default = {
    isDefault = true;
    extensions = with addons; [
      tridactyl
      ublock-origin
      floccus
      keepassxc-browser
      darkreader
    ];
    search = {
      force = true;
      default = "ecosia";
      engines = {
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
          iconUpdateURL = nix_favicon;
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
          urls = [{
            template = "https://nixos.wiki/index.php?search={searchTerms}";
          }];
          iconUpdateURL = nix_favicon;
          inherit updateInterval;
          definedAliases = [ "<nw" ];
        };

        "Home Manager Option Search" = {
          urls = [{
            template =
              "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
          }];
          iconUpdateURL = nix_favicon;
          inherit updateInterval;
          definedAliases = [ "<ho" ];
        };

        "Rust Std" = {
          urls = [{
            template = "https://doc.rust-lang.org/std/?search={searchTerms}";
          }];
          iconUpdateURL =
            "https://www.rust-lang.org/static/images/rust-logo-blk.svg";
          inherit updateInterval;
          definedAliases = [ "<rsd" ];
        };

        "Crates.io" = {
          urls = [{ template = "https://crates.io/search?q={searchTerms}"; }];
          iconUpdateURL = "https://crates.io/assets/cargo.png";
          inherit updateInterval;
          definedAliases = [ "<cr" ];
        };

        "Pip / PyPi" = {
          urls = [{ template = "https://pypi.org/search/?q={searchTerms}"; }];
          iconUpdateURL =
            "https://www.python.org/static/opengraph-icon-200x200.png";
          inherit updateInterval;
          definedAliases = [ "<pip" "<py" ];
        };

        "Wikipedia DE" = {
          urls =
            [{ template = "https://de.wikipedia.org/wiki/{searchTerms}"; }];
          iconUpdateURL =
            "https://upload.wikimedia.org/wikipedia/commons/5/5a/Wikipedia%27s_W.svg";
          inherit updateInterval;
          definedAliases = [ "<wd" ];
        };

        "Wikipedia EN" = {
          urls =
            [{ template = "https://en.wikipedia.org/wiki/{searchTerms}"; }];
          iconUpdateURL =
            "https://upload.wikimedia.org/wikipedia/commons/5/5a/Wikipedia%27s_W.svg";
          inherit updateInterval;
          definedAliases = [ "<we" ];
        };

        "Invidious (nerdvpn.de)" = {
          urls = [{
            template = "https://invidious.nerdvpn.de/search?q={searchTerms}";
          }];
          iconUpdateURL = "https://docs.invidious.io/images/invidious.png";
          inherit updateInterval;
          definedAliases = [ "<yt" "<inv" ];
        };

        "addy.io" = {
          urls = [{
            template =
              "https://app.addy.io/aliases?shared_domain=true&active=true&search={searchTerms}";
          }];
          definedAliases = [ "<addy" "<anon" ];
          iconUpdateURL = favicon "addy.io";
          inherit updateInterval;
        };

        "mdi-icons" = {
          urls = [{
            template = "https://pictogrammers.com/library/mdi?q={searchTerms}";
          }];
          definedAliases = [ "<mdi" "<i1" ];
          iconUpdateURL = favicon "pictogrammers.com";
          inherit updateInterval;
        };

        "simpleicons" = {
           urls = [{
            template = "https://simpleicons.org/?q={searchTerms}";
          }];
          definedAliases = [ "<si" "<i2" ];
          iconUpdateURL = favicon "simpleicons.org";
          inherit updateInterval;
        };

        "Startpage" = {
          urls = [{
            template = "https://www.startpage.com/sp/search";
            params = [
              {
                name = "query";
                value = "{searchTerms}";
              }
              {
                name = "cat";
                value = "web";
              }
            ];
          }];
          definedAliases = [ "<sp" ];
          iconUpdateURL =
            "https://www.startpage.com/sp/cdn/images/startpage-logo-gradient-dark.svg";
          inherit updateInterval;
        };

        "DuckDuckGo" = {
          urls = [{
            template = "https://duckduckgo.com";
            params = [
              {
                name = "t";
                value = "ffab";
              }
              {
                name = "ia";
                value = "web";
              }
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }];
          iconUpdateURL =
            "https://duckduckgo.com/duckduckgo-help-pages/logo.v109.svg";
          inherit updateInterval;
          definedAliases = [ "<ddg" ];
        };

        "alternativeto.net" = {
          urls = [{
            template =
              "https://alternativeto.net/browse/search/?q={searchTerms}";
          }];
          iconUpdateURL =
            "https://cdn-1.webcatalog.io/catalog/alternativeto/alternativeto-icon-filled.png";
          inherit updateInterval;
          definedAliases = [ "<alto" ];
        };

        "thingiverse" = {
          urls = [{
            template =
              "https://www.thingiverse.com/search?q={searchTerms}&page=1";
          }];
          iconUpdateURL = "https://www.thingiverse.com/favicon.ico";
          inherit updateInterval;
          definedAliases = [ "<thing" ];
        };

        "ecosia" = {
          urls = [{
            template =
              "https://www.ecosia.org/search?method=index&q={searchTerms}";
          }];
          iconUpdateURL = "https://www.ecosia.org/favicon.ico";
          inherit updateInterval;
        };

      } // gh_search ({
        type = "repositories";
        alias = "r";
        addAliases = [ "gh" ];
      }) # <ghr or <gh
        // gh_search ({
          type = "users";
          alias = "u";
        }) # <ghu

        // gh_search ({
          type = "repositories";
          alias = "r";
          personal = true;
          addAlias = [ "ghp" ];
        }) # <ghpr or <ghp
        // gh_search ({
          type = "users";
          alias = "u";
          personal = true;
        }) # <ghpu
        // gh_search ({
          type = "issues";
          alias = "i";
          personal = true;
        }) # <ghpi
      ;
    };
  };
}
