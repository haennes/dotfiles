{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  jq-schema = pkgs.writeShellScriptBin "jq-schema" ''
    set -euo pipefail
    ${lib.getExe pkgs.jq} -n "$(cat ${inputs.schema-jq}/schema.jq)
schema(inputs)" "$@"
  '';
in
{
  options.my.utils.jq.enable = mkEnableOption "jq" // {
    default = config.my.utils.enable;
  };
  config = mkIf config.my.utils.jq.enable {
    home.packages = with pkgs; [
      jq
      jq-schema
    ];
  };
}
