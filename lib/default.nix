{ }: {
  age_obtain_user_password = username: {
    age.secrets.${"${username}"} = {
      file = ../secrets/user_passwords/${username}.age;
      owner = "root";
      group = "root";
    };
  };
  get_key_string_unsafe = { secret_name }:
    {
      #age.secrets.${secret_name}
    };
}
