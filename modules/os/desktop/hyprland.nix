{ pkgs, inputs, config, lib, username, ... }:

let
  cfg = config.my.desktop.hyprland;
in {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  options.my.desktop.hyprland = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    services.greetd = {
      enable = true;
      settings = let
        session = {
          user = username;
          command = let
            sessionVars = "/etc/profiles/per-user/${username}/etc/profile.d/hm-session-vars.sh";
          in pkgs.writeShellScript "hyprland-hm-session-vars" ''
            [ -f ${sessionVars} ] && . ${sessionVars}
            exec ${config.programs.hyprland.package}/bin/Hyprland
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

    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

    security = {
      polkit.enable = lib.mkDefault true;
      pam = {
        services = {
          greeetd.gnupg.enable = true;
          login.enableGnomeKeyring = true;
          swaylock.text = ''
          auth include login
        '';
        };
      };
    };
  };
}
