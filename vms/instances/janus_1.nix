{ pkgs, config, ... }@inputs: {
  imports = [ (import ../instantiable/janus "janus_1" inputs) ];
}
