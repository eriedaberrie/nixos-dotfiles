{ pkgs, config, lib, inputs, username, ... }:

let
  cfg = config.my.networking;
in {
  imports = [
    inputs.wolfangaukang.nixosModules.cloudflare-warp
  ];

  options.my.networking = {
    networkManager.enable = lib.mkEnableOption null;
    warp.enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.networkManager.enable {
    networking.networkmanager = {
      enable = true;
      wifi = {
        backend = lib.mkDefault "iwd";
        scanRandMacAddress = lib.mkDefault false;
      };
    };

    systemd.services.NetworkManager-wait-online.enable = lib.mkDefault false;
    users.users.${username}.extraGroups = [ "networkmanager" ];

    services.cloudflare-warp = lib.mkIf cfg.warp.enable {
      enable = true;
      package = pkgs.stablePkgs.cloudflare-warp;
    };
  };
}
