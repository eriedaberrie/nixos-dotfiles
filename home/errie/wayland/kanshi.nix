{ ... }:

{
  services.kanshi = {
    enable = false; # Too many problems
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
        exec = "eww-bar-open";
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
}
