{ inputs, system, ... }:
with inputs;
{
  imports = [ agenix.nixosModules.default ];
  environment.systemPackages = [ agenix.packages."${system}".default ];
}
