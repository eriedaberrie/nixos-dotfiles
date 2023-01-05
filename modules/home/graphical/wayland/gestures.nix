{ pkgs, config, lib, ... }:

let
  cfg = config.my.graphical.wayland.gestures;
in {
  options.my.graphical.wayland.gestures = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = let
      serviceName = "libinput-gestures.service";
      service = "${pkgs.libinput-gestures}/share/systemd/user/${serviceName}";
    in {
      "systemd/user/${serviceName}".source = service;
      "systemd/user/hyprland-session.target.wants/${serviceName}".source = service;
      "libinput-gestures.conf" = {
        text = let
          hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
        in ''
          gesture pinch in 4 ${hyprctl} dispatch killactive
        '';
        onChange = ''
          ${pkgs.systemd}/bin/systemctl --user restart ${serviceName}
        '';
      };
    };
  };
}
