{ config, lib, username, ... }:

let
  cfg = config.my.wireshark;
in {
  options.my.wireshark = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    programs.wireshark.enable = true;
    users.users.${username}.extraGroups = [ "wireshark" ];
  };
}
