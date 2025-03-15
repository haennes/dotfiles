{ pkgs, config, ... }@inputs: {
  imports = [ (import ../instantiable/hesperos "hesperos_1" inputs) ];
}
