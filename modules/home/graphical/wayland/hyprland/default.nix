{ pkgs, inputs, config, lib, osConfig, theme, ... }:

let
  cfg = config.my.graphical.wayland.hyprland;
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  options.my.graphical.wayland.hyprland = {
    enable = lib.mkEnableOption null;
    swaybg = {
      enable = lib.mkEnableOption null // {
        default = true;
      };
      wallpaper = lib.mkOption {
        type = lib.types.pathInStore;
        default = ../../../../../assets/kevin-laminto-unsplash-catppuccin.png;
      };
    };
  };

  config = lib.mkIf cfg.enable (let
    startHyprland = pkgs.writeShellScript "start-hyprland" ''
      [ -n "$GREETD_SOCK" ] && ${pkgs.swaylock-effects}/bin/swaylock ${
        lib.optionalString (cfg.swaybg.enable) "-i ${cfg.swaybg.wallpaper}"
      } &
    '';
    toggleOption = pkgs.writeShellScriptBin "hypr-toggle-opt" ''
      hyprctl keyword "$1" "$(hyprctl getoption "$1" -j | ${pkgs.jaq}/bin/jaq '1 - .int')"
    '';
    winShiftS = with pkgs; writeShellScriptBin "win-shift-s" ''
      FILENAME="/tmp/win-shift-s-$PPID.png"
      MONITOR="$(hyprctl monitors -j | ${_ jaq} -r '.[] | select(.focused)')"
      ${_ grim} -o "$(${_ jaq} -r '.name' <<< "$MONITOR")" "$FILENAME"
      ${_ imv} -f "$FILENAME" & IMV_PROC=$!
      DIMENSIONS="$(${_ slurp} -f '%wx%h+%X+%Y')"
      [ "$?" -eq 0 ] && \
        ${_ imagemagick} "$FILENAME" -crop "$DIMENSIONS" - | \
        ${wl-clipboard}/bin/wl-copy -t image/png
      kill $IMV_PROC
      exec rm "$FILENAME"
    '';
  in {
    home.packages = [
      toggleOption
      (inputs.watershot.packages.${pkgs.system}.default.overrideAttrs (old: {
        doCheck = false;
      }))
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = osConfig.programs.hyprland.package;
      extraConfig = ''
      ${
        builtins.concatStringsSep "\n"
          (lib.mapAttrsToList (name: value: "\$${name} = 0xFF${value}") theme) 
      }
      exec-once = ${startHyprland}
      ${builtins.readFile ./hyprland.conf}
    '';
    };

    systemd.user.services.swaybg = lib.mkIf cfg.swaybg.enable {
      Unit = {
        Description = "Background wallpaper image";
        After = "hyprland-session.target";
      };
      Service = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${cfg.swaybg.wallpaper} -m fill -o '*'";
      };
      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
    };
  });
}
