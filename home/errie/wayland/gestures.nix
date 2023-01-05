{ pkgs, inputs, lib, ... }:

{
  xdg.configFile = let
    serviceName = "libinput-gestures.service";
    service = "${pkgs.libinput-gestures}/share/systemd/user/${serviceName}";
  in {
    "systemd/user/${serviceName}".source = service;
    "systemd/user/graphical-session.target.wants/${serviceName}".source = service;
    "libinput-gestures.conf" = {
      text = let
        hyprctl = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl";
        _ = lib.getExe;
      in ''
        gesture pinch in 4 ${hyprctl} dispatch killactive
      '';
      onChange = ''
        ${pkgs.systemd}/bin/systemctl --user restart ${serviceName}
      '';
    };
  };
}
