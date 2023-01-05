{ pkgs, inputs, username, ... }:

{
  imports = [
    inputs.agenix.nixosModules.age
  ];

  environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.default ];

  age.secrets.spotify = {
    file = ../../../../secrets/spotify.age;
    owner = username;
    group = "users";
  };
  age.secrets.nix-tokens = {
    file = ../../../../secrets/nix-tokens.age;
    mode = "440";
    owner = username;
    group = "users";
  };
  age.secrets.authinfo = {
    file = ../../../../secrets/authinfo.age;
    owner = username;
    group = "users";
  };
  age.secrets.email = {
    file = ../../../../secrets/email.json.age;
    name = "email.json";
    owner = username;
    group = "users";
  };
  age.secrets.porkbun-auth = {
    file = ../../../../secrets/porkbun-auth.age;
    name = "porkbun-auth";
  };
}
