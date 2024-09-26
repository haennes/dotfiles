{ lib, config, hports, ... }: {
  services.tasks_md = {
    enable = true;
    conf = let
      tports = config.ports.ports.curr_ports.tasks;
      simple = name: {
        title = name;
        port = tports.${name};
      };
    in lib.lists.map (item:
      item // {
        domain = "tasks.localhost";
        config_dir = "/home/hannses/tasks/${item.title}/config";
        tasks_dir = "/home/hannses/tasks/${item.title}/tasks";
        base_path = "/${item.title}";
      }) [
        (simple "uni")
        (simple "haushalt")
        (simple "projekte")
        (simple "coding")
      ];
  };
}
