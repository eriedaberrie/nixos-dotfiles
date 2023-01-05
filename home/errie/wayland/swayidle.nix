{ pkgs, lib, ... }:

{
  services.swayidle = let
    inherit (pkgs) brightnessctl acpi gnugrep systemd swaylock-effects;
    _ = lib.getExe;
  in {
    enable = true;
    systemdTarget = "hyprland-session.target";
    timeouts = [
      {
        timeout = 60;
        command = "${_ brightnessctl} -s s 3%";
        resumeCommand = "${_ brightnessctl} -r";
      }
      {
        timeout = 300;
        command = "${_ acpi} -b | ${_ gnugrep} -q 'Discharging' && ${systemd}/bin/systemctl suspend";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${_ swaylock-effects} -f -S --effect-blur 15x3";
      }
    ];
  };
}
