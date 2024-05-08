{ config, lib, pkgs, ... }:
with lib;
with lib.lists;
with lib.types;
let
  settingsFormat = pkgs.formats.json { }; # COPIED
  cfg = config.services.syncthing_wrapper;
  dev_name = cfg.dev_name;
  take_last_n = n: l: reverseList (take 2 (reverseList l));
  dev_id_list_to_attr = l: {
    name = head l;
    value = { id = (last l); };
  }; # [$device $id] -> $device = $id

  ungroup = set:
    collect isList
    (mapAttrsRecursiveCond (as: !(isString as)) (vals: name: vals ++ [ name ])
      set); # evals to a list of groups
  devices_in_given_group = group_list:
    listToAttrs (map (l: dev_id_list_to_attr (take_last_n 2 l)) group_list);
  devices_in_group = group_list: name:
    devices_in_given_group (filter (v: elem name v)
      group_list); # input is ungrouped returns a group list
  all_devices = devices_in_given_group (ungroup cfg.devices);
  all_devices_but_me = removeAttrs all_devices [ dev_name ]; # {$name.id = $id}

  devices_type_folders = anything;

in with lib; {
  options.services.syncthing_wrapper = {
    enable = mkEnableOption "syncting_wrapper";
    dev_name = mkOption {
      type = types.str;
      default = config.networking.hostName;
    };
    devices = mkOption {
      #type = types.attrsOf (either 
      #(types.attrsOf str) #grouped
      #str  # not grouped
      #);
      apply = old: { all = old; };
      description = lib.mdDoc ''
        add devices under n layerss of groups
        all devices are **automatically** added to the **all**-group as well as to the **group** of thier **own name**
      '';
      example = {
        "devicea" = "ida";
        groupa = {
          "deviceb" = "idb";
          "devicec" = "idc";
          groupc = { deviced = "idd"; };
        };
      };
    };
    folders = mkOption { # THIS IS COPIED FROM THE SYNCTHING MODULE
      type = types.attrsOf (either (types.submodule ({ name, ... }: {
        freeformType = settingsFormat.type;
        options = {
          path = mkOption {
            # TODO for release 23.05: allow relative paths again and set
            # working directory to cfg.dataDir
            type = types.str // {
              check = x:
                types.str.check x
                && (substring 0 1 x == "/" || substring 0 2 x == "~/");
              description = types.str.description + " starting with / or ~/";
            };
            default = name;
            description = lib.mdDoc ''
              The path to the folder which should be shared.
              Only absolute paths (starting with `/`) and paths relative to
              the [user](#opt-services.syncthing.user)'s home directory
              (starting with `~/`) are allowed.
            '';
          };

          id = mkOption {
            type = types.str;
            default = name;
            description = lib.mdDoc ''
              The ID of the folder. Must be the same on all devices.
            '';
          };

          label = mkOption {
            type = types.str;
            default = name;
            description = lib.mdDoc ''
              The label of the folder.
            '';
          };

          devices = mkOption {
            type = devices_type_folders;
            #supports attrset (see device group) or list of (attrset or string)
            apply = old: if isAttrs old then [ old ] else old;
            default = [ ];
            description = mdDoc ''
              The devices this folder should be shared with. Each device must
              be defined in the [devices](#opt-services.syncthing.settings.devices) option.
            '';
          };

          versioning = mkOption {
            default = cfg.default_versioning;
            description = mdDoc ''
              How to keep changed/deleted files with Syncthing.
              There are 4 different types of versioning with different parameters.
              See <https://docs.syncthing.net/users/versioning.html>.
            '';
            example = literalExpression ''
              [
                {
                  versioning = {
                    type = "simple";
                    params.keep = "10";
                  };
                }
                {
                  versioning = {
                    type = "trashcan";
                    params.cleanoutDays = "1000";
                  };
                }
                {
                  versioning = {
                    type = "staggered";
                    fsPath = "/syncthing/backup";
                    params = {
                      cleanInterval = "3600";
                      maxAge = "31536000";
                    };
                  };
                }
                {
                  versioning = {
                    type = "external";
                    params.versionsPath = pkgs.writers.writeBash "backup" '''
                      folderpath="$1"
                      filepath="$2"
                      rm -rf "$folderpath/$filepath"
                    ''';
                  };
                }
              ]
            '';
            type = with types;
              nullOr (submodule {
                freeformType = settingsFormat.type;
                options = {
                  type = mkOption {
                    type = enum [ "external" "simple" "staggered" "trashcan" ];
                    description = mdDoc ''
                      The type of versioning.
                      See <https://docs.syncthing.net/users/versioning.html>.
                    '';
                  };
                };
              });
          };

          copyOwnershipFromParent = mkOption {
            type = types.bool;
            default = false;
            description = mdDoc ''
              On Unix systems, tries to copy file/folder ownership from the parent directory (the directory it’s located in).
              Requires running Syncthing as a privileged user, or granting it additional capabilities (e.g. CAP_CHOWN on Linux).
            '';
          };
        };
      })) devices_type_folders);
    };

    default_versioning = mkOption {
      default = null;
      description = mdDoc ''
        How to keep changed/deleted files with Syncthing.
        There are 4 different types of versioning with different parameters.
        See <https://docs.syncthing.net/users/versioning.html>.
      '';
      example = literalExpression ''
        [
          {
            default_versioning = {
              type = "simple";
              params.keep = "10";
            };
          }
          {
            default_versioning = {
              type = "trashcan";
              params.cleanoutDays = "1000";
            };
          }
          {
            default_versioning = {
              type = "staggered";
              fsPath = "/syncthing/backup";
              params = {
                cleanInterval = "3600";
                maxAge = "31536000";
              };
            };
          }
          {
            default_versioning = {
              type = "external";
              params.versionsPath = pkgs.writers.writeBash "backup" '''
                folderpath="$1"
                filepath="$2"
                rm -rf "$folderpath/$filepath"
              ''';
            };
          }
        ]
      '';
      type = with types;
        nullOr (submodule {
          freeformType = settingsFormat.type;
          options = {
            type = mkOption {
              type = enum [ "external" "simple" "staggered" "trashcan" ];
              description = mdDoc ''
                The type of versioning.
                See <https://docs.syncthing.net/users/versioning.html>.
              '';
            };
          };
        });
    };
  };
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      # override options are set. Use mkForce to override
      overrideDevices = true;
      overrideFolders = true;
      openDefaultPorts = true;
      settings = {
        devices = all_devices;
        folders = filterAttrs (n: v: elem dev_name v.devices) (mapAttrs
          (name: value:
            let
              val = if isList value then {
                devices = value;
                versioning = cfg.default_versioning;
              } else
                value;
              def_path = config.services.syncthing.dataDir + "/" + name;
            in removeAttrs (
              #{
              #  versioning = cfg.default_versioning;
              # val seems to be a string
              #}
              #//
              val // {
                devices = flatten (map (dev:
                  if isString dev then
                    lib.attrNames (devices_in_group (ungroup cfg.devices) dev)
                  else
                    lib.attrNames (devices_in_given_group (ungroup dev)))
                  val.devices); # evals incorrectly
                #path = mkIf (value ? paths)
                #(mkIf (value.paths ? "${dev_name}") value.paths."${dev_name}");
                path = if (val ? paths) then
                  (if (val.paths ? "${dev_name}") then
                    val.paths."${dev_name}"
                  else
                    def_path)
                else
                  def_path;
                #path = def_path;
              }) [ "paths" ]) cfg.folders);
        ##devices = lib.mapAttrs (name: value: {id = value;}) devices;
        ##folders =
        ##lib.filterAttrs (n: v: builtins.elem dev_name v.devices) folders_list;
        ##folders = ( builtins.listToAttrs ( 
        ##    builtins.map (name_devices: {
        ##        name = name_devices.name;
        ##        value = {
        ##	    inherit versioning;
        ##	    path = config.services.syncthing_wrap.dataDir + "/" + name_devices.name;
        ##	    # always sync to server
        ##          devices = builtins.attrNames name_devices.devices;
        ##          #devices = removeAttrs ( builtins.attrNames name_devices.devices  ) dev_name;
        ##        };
        ##    })
        ##    folders_list
        ##));
        options = {
          urAccepted = -1; # do not send reports
          relaysEnabled = true;
        };
        #  
      };
    };
    # Syncthing ports: 8384 for remote access to GUI
    # 22000 TCP and/or UDP for sync traffic
    # 21027/UDP for discovery
    # source: https://docs.syncthing.net/users/firewall.html
    networking.firewall.allowedTCPPorts = [ 8384 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 21027 ];

    #TODO
    #services.syncthing.extraOptions.gui = {
    #    user = "username";
    #    password = "password";
    #};
  };

}
