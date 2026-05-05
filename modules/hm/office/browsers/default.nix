{
  lib,
  config,
  inputs,
  pkgs,
  ...
}@hm_inputs:
let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types)
    str
    lazyAttrsOf
    submodule
    listOf
    int
    ;
  updateInterval = 24 * 60 * 60 * 1000; # every day
  favicon = domain: "https://${domain}/favicon.ico"; # TODO use this instead
  engines_inputs = hm_inputs // {
    inherit favicon updateInterval;
  };

in
{
  options.my.office.browsers = {
    enable = mkEnableOption "web browsers" // {
      default = config.my.office.enable;
    };
    search = {
      engines = mkOption {
        type = lazyAttrsOf (
          submodule (
            { name, ... }:
            {
              options = {
                name = mkOption {
                  type = str;
                  default = name;
                };
                urls = mkOption {
                  type = listOf (submodule {
                    options = {
                      template = mkOption {
                        type = str;
                      };
                      params = mkOption {
                        type = listOf (submodule {
                          options = {
                            name = mkOption {
                              type = str;
                            };
                            value = mkOption {
                              type = str;
                            };
                          };
                        });
                        default = [ ];
                      };
                    };
                  });
                  default = [ ];
                };
                icon = mkOption {
                  type = str;
                  default = "";
                };
                definedAliases = mkOption {
                  type = listOf str;
                  default = [ ];
                };
                updateInterval = mkOption {
                  type = int;
                  default = updateInterval;
                };
                metaData.hidden = mkEnableOption "";
              };
            }
          )
        );
      };
      default = mkOption {
        type = str;
        default = "ecosia";
      };
    };
  };

  config.my.office.browsers.search.engines = lib.my.recursiveMerge (
    lib.attrValues (
      inputs.haumea.lib.load {
        src = ./engines;
        inputs = engines_inputs;
        loader = inputs.haumea.lib.loaders.default;
      }
    )
  );
  imports = [
    ./firefox
  ];
}
