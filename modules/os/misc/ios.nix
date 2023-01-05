{ pkgs, config, lib, ... }:

let
  cfg = config.my.ios;
in {
  options.my.ios = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    services.usbmuxd.enable = true;
    environment.systemPackages = with pkgs; [
      libimobiledevice
      ifuse
    ];
  };
}
