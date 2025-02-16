{ lib, config, ... }: {
  services.tasks_md =
    lib.mkIf (config.services.syncthing.settings.folders ? "tasks") {
      enable = true;
      enableNginx = lib.mkDefault true;
      conf = let
        tports = config.ports.ports.curr_ports.tasks;
        simple = name: {
          title = name;
          port = tports.${name};
        };
        base_dir = config.services.syncthing.settings.folders.tasks.path;
      in lib.lists.map (item:
        item // {
          #domain = (if (config.is_client) then "tasks.localhost" else hips.wg0);
          domain = "tasks.localhost";
          config_dir = "${base_dir}/${item.title}/config";
          tasks_dir = "${base_dir}/${item.title}/tasks";
          base_path = "/${item.title}";
        }) [
          (simple "uni")
          (simple "haushalt")
          (simple "projekte")
          (simple "coding")
        ];
    };
}
