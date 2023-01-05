{ pkgs, config, lib, ... }:

let
  cfg = config.my.graphical.zathura;
in {
  options.my.graphical.zathura = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      extraConfig = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "zathura";
        rev = "d85d8750acd0b0247aa10e0653998180391110a4";
        sha256 = "1hv9wzjyg34533qaxc5dc3gy8fcyvpvzcri2aip1kf4varnpcn75";
      } + "/src/catppuccin-mocha");
    };
  };
}
