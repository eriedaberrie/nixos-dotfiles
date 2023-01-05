{ config, lib, ... }:

let
  cfg = config.my.graphical.wayland.gammastep;
in {
  options.my.graphical.wayland.gammastep = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
      temperature = {
        day = 6500;
        night = 2750;
      };
      settings = {
        general = {
          fade = 1;
          adjustment-method = "wayland";
        };
      };
    };
  };
}
