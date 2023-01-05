{ config, lib, ... }:

let
  cfg = config.my.location;
in {
  options.my.location = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    services.geoclue2.enable = true;
    location.provider = "geoclue2";
    services.localtimed.enable = true;
  };
}
