{ pkgs, config, lib, ... }:

let
  cfg = config.my.desktop.applications;
in {
  options.my.desktop.applications = {
    enable = lib.mkEnableOption null // {
      default = config.my.desktop.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl
      acpi
      intel-gpu-tools
      powertop
    ];
  };
}
