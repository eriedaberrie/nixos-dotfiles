{ pkgs, config, lib, self, ... }:

let
  cfg = config.my.graphical.wayland;
in {
  imports = [
    ./anyrun.nix
    ./hyprland
    ./eww
    ./swaylock.nix
    ./swayidle.nix
    ./gammastep.nix
    ./kanshi.nix
    ./gestures.nix
    ./ydotool.nix
    ./foot.nix
    ./fuzzel.nix
  ];

  options.my.graphical.wayland = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    home.packages = (with pkgs; [
      wl-clipboard
      grim
      slurp
      wev
      self.packages.${system}.geticons
    ]);
  };
}
