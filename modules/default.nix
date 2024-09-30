{ ... }: {
  imports = [
    ./age.nix
    #./adb.nix #uncomment if needed
    ./all
    ./gnome
    ./headfull
    ./headless
    ./home_manager
    ./machine_properties.nix
  ];
}
