{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./tlp.nix
  ];

  time.timeZone = "America/Los_Angeles";

  my = {
    bootloader.type = "systemdBoot";

    fs = {
      bootPartition = true;
      snapshots = true;
      type = "btrfs";
    };

    networking = {
      networkManager.enable = true;
      warp.enable = true;
    };

    bin-compat.enable = true;
    docker.enable = true;
    interception.enable = true;
    ios.enable = true;
    wireshark.enable = true;

    cli = {
      fish.enable = true;
      nix-index.enable = true;
    };

    desktop = {
      enable = true;
      audio.enable = true;
      bluetooth.enable = true;
      gaming.enable = true;
      hyprland.enable = true;
      printing.enable = true;
    };
  };

  # networking.firewall.enable = false;

  systemd.services.nginx.wantedBy = lib.mkForce [ ];

  environment.systemPackages = with pkgs; [
    gcc
    dos2unix
  ];

  programs = {
    zsh.enable = true;
    git.package = pkgs.gitFull;
  };

  services = {
    flatpak.enable = true;

    openssh.enable = true;

    mysql = {
      enable = true;
      package = pkgs.mysql80;
    };

    nginx = {
      enable = true;
      virtualHosts."127.0.0.1" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 80;
          }
        ];
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };
    };
  };

  system.stateVersion = "22.11";
}
