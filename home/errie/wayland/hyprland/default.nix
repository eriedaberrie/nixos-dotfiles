{ pkgs, lib, inputs, config, ... }:

let
  _ = pkg: lib.getExe pkg;
  startHyprland = with pkgs; let
    wallpaper = ../../assets/kevin-laminto-unsplash-catppuccin.png;
  in writeShellScript "start-hyprland" ''
    [ -n "$GREETD_SOCK" ] && ${_ swaylock-effects} -i ${wallpaper} &
    eww-bar-open &
    ${_ swaybg} -i ${wallpaper} -m fill -o '*' &
  '';
  winShiftS = with pkgs; writeShellScriptBin "win-shift-s" ''
    FILENAME="/tmp/win-shift-s-''${PPID}.png"
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
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  home.packages = [
    winShiftS
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile (pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "hyprland";
      rev = "15383218340309cd77d1dc501bfa82c30c45067f";
      sha256 = "16xb1kghqamvn10ypd004kqcqcvp847dy1x2lbwkqhkf0gsgyh1z";
    } + "/themes/mocha.conf") + ''
      exec-once = ${startHyprland}
    '' + builtins.readFile ./hyprland.conf;
  };
}
