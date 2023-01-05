{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xdg-utils
    libnotify
    pulsemixer
    pavucontrol
  ];
}
