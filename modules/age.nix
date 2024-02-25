{ inputs, system, ... }:
with inputs; {
  imports = [ agenix.nixosModules.default ];
  config = {
    environment.systemPackages = [ agenix.packages."${system}".default ];
  };
}
