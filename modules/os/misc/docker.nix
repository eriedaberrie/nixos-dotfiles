{ config, lib, username, ... }:

let
  cfg = config.my.docker;
in {
  options.my.docker = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.${username}.extraGroups = [ "docker" ];
  };
}
