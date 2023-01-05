{ pkgs, config, lib, ... }:

let
  cfg = config.my.desktop.printing;
in {
  options.my.desktop.printing = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    services = {
      printing = {
        enable = true;
        cups-pdf.enable = true;
        drivers = [ pkgs.gutenprint ];
      };
      avahi = {
        enable = true;
        nssmdns = true;
        openFirewall = true;
      };
    };
  };
}
