{ pkgs, ... }:

{
  gtk = {
    enable = true;
    font = {
      package = pkgs.inter;
      name = "Inter";
      size = 11;
    };
    iconTheme = {
      package = pkgs.catppuccin-folders-mocha;
      name = "Papirus-Dark";
    };
    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = [ "teal" ];
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
      name = "Catppuccin-Mocha-Standard-Teal-Dark";
    };
  };
}
