{ ... }:
{
  ageObtainUserPassword = username: config: {
    age.secrets.${"${username}"} = {
      file = ../secrets/user_passwords/${username}.age;
      owner = "root";
      group = "root";
    };
  };
  genUser = name: {
    "${name}" = {
      isNormalUser = true;
      description = name;
      home = "/home/${name}";
    };
  };

}
