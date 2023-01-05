{ pkgs, lib, config, ... }:

{
  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.greetd = {
    enable = true;
    settings = let
      session = rec {
        user = "errie";
        command = let
          sessionVars = "/etc/profiles/per-user/${user}/etc/profile.d/hm-session-vars.sh";
        in pkgs.writeShellScript "hyprland-hm-session-vars" ''
          [ -f ${sessionVars} ] && . ${sessionVars}
          exec ${lib.getExe config.programs.hyprland.package}
        '';
      };
    in {
      initial_session = session;
      default_session = session;
    };
  };
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';

  fonts = {
    fonts = with pkgs; [
      corefonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      font-awesome
      dejavu_fonts
      inter
      lmodern
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
          "DejaVuSansMono"
        ];
      })
    ];
  };
}
