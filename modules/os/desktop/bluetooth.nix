{ config, lib, ... }:

let
  cfg = config.my.desktop.bluetooth;
in {
  options.my.desktop.bluetooth = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General.Enable = "Source,Sink,Media,Socket";
      };
    };
    services.blueman.enable = true;
  };
}
