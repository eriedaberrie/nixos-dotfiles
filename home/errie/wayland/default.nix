{ pkgs, ... }:

{
  imports = [
    ./hyprland
    ./eww
    ./swaylock.nix
    ./swayidle.nix
    ./kanshi.nix
    ./gestures.nix
    ./ydotool.nix
    ./gtk.nix
    ./qt.nix
    ./foot.nix
    ./fuzzel.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    grim
    slurp
    wev
    geticons
  ];
}
