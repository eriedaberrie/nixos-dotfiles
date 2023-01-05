{ pkgs, config, lib, ... }:

let
  cfg = config.my.graphical.wayland.swayidle;
in {
  options.my.graphical.wayland.swayidle = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    services.swayidle = let
      inherit (pkgs) brightnessctl acpi gnugrep systemd swaylock-effects;
    in {
      enable = true;
      systemdTarget = "hyprland-session.target";
      timeouts = let
        withBat = command: "${acpi}/bin/acpi -b | ${gnugrep}/bin/grep -q 'Discharging' && ${command}";
      in [
        {
          timeout = 60;
          command = withBat "${brightnessctl}/bin/brightnessctl -s s 3%";
          resumeCommand = withBat "${brightnessctl}/bin/brightnessctl -r";
        }
        {
          timeout = 300;
          command = withBat "${systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${swaylock-effects}/bin/swaylock -f -S --effect-blur 15x3";
        }
      ];
    };
  };
}
