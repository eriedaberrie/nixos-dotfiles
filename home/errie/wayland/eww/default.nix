{ pkgs, ... }:

let
  ewwBarOpen = pkgs.writeScriptBin "eww-bar-open" ''
    # Lack of quotes intentional
    exec eww open-many $(hyprctl monitors -j | jaq -r '.[] | .id' | sed 's/^/bar/')
  '';
in {
  home.packages = with pkgs; [
    eww-wayland
    acpi
    ewwBarOpen
  ];
  xdg.configFile = {
    "eww/eww.yuck".source = ./eww.yuck;
    "eww/eww.scss".source = ./eww.scss;
    "eww/assets".source = ./assets;
    "eww/_mocha.scss".source = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "palette";
      rev = "ec883a880bc24d43a01c78e7d9602abf6b1780dd";
      sha256 = "1zzjpd0g6ir4rfmaci21n4nqv13z6559a3gcvw90k9510pw4z9cj";
    } + "/scss/_mocha.scss";
  };
}
