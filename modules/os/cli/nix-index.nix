{ inputs, config, lib, ... }:

let
  cfg = config.my.cli.nix-index;
in {
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  options.my.cli.nix-index = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    programs.nix-index = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
    };
  };
}
