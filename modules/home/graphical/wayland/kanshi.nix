{ pkgs, config, lib, ... }:

let
  cfg = config.my.graphical.wayland.kanshi;
in {
  options.my.graphical.wayland.kanshi = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    services.kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      profiles = {
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              scale = 1.0;
            }
          ];
        };
        docked = {
          exec = "${pkgs.systemd}/bin/systemctl --user restart eww-bar.service";
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "HDMI-A-1";
              status = "enable";
            }
          ];
        };
      };
    };
  };
}
