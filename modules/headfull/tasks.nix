{lib, ...}:{
services.tasks_md = {
  enable = true;
  conf =
  map(item: item // {
    domain = "tasks.localhost";
    config_dir = "/home/hannses/tasks/${item.title}/config";
    tasks_dir = "/home/hannses/tasks/${item.title}/tasks";
    base_path = "/${item.title}";
    }
  )
  [
  {
    title = "uni";
    port = 9081;
  }
  {
    title = "haushalt";
    port = 9082;
  }
  {
    title = "projekte";
    port = 9083;
  }
  {
    title = "coding";
    port = 9084;
  }
  ];
};
}
