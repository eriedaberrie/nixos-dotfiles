{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [ qt5ct libsForQt5.lightly ];
    sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";
  };
  xdg.configFile = {
    "qt5ct/colors/Catppuccin-Mocha.conf".source = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "qt5ct";
      rev = "c50c9e7c6ba0ca12a107a6111b7941da94f5327c";
      sha256 = "1rfqwawy5971iz8q3c5m34r2jqsnip6wb2j8xf7zn0bn6qi97nbj";
    } + "/Catppuccin-Mocha.conf";
    "lightlyrc".text = ''
      [Style]
      AnimationsDuration=150
      DolphinSidebarOpacity=84
      WidgetDrawShadow=false
    '';
  };
}
