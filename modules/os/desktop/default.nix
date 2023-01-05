{ pkgs, config, lib, ... }:

let
  cfg = config.my.desktop;
in {
  imports = [
    ./applications.nix
    ./audio.nix
    ./bluetooth.nix
    ./gaming.nix
    ./hyprland.nix
    ./printing.nix
  ];

  options.my.desktop = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    # Stop auto suspending
    services.logind.lidSwitch = "ignore";

    fonts.packages = with pkgs; [
      corefonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      font-awesome
      dejavu_fonts
      jost
      inter
      lmodern
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
          "DejaVuSansMono"
          "RobotoMono"
        ];
      })
    ];

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
