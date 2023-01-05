{ ... }:

{
  age.secrets.spotify = {
    file = ../../secrets/spotify.age;
    owner = "errie";
    group = "users";
  };
  age.secrets.nix-tokens = {
    file = ../../secrets/nix-tokens.age;
    mode = "440";
    owner = "errie";
    group = "users";
  };
  age.secrets.authinfo = {
    file = ../../secrets/authinfo.age;
    owner = "errie";
    group = "users";
  };
}
