{ config, lib, ... }:

let
  cfg = config.my.fs;
in {
  imports = [
    ./btrfs.nix
    ./ext4.nix
  ];

  options.my.fs = {
    bootPartition = lib.mkEnableOption null // {
      default = true;
    };
    snapshots = lib.mkEnableOption null;
    swapPart = lib.mkEnableOption null // {
      default = true;
    };
    type = lib.mkOption {
      type = with lib.types; nullOr (enum [ "btrfs" "ext4" ]);
      default = null;
    };
  };

  config = {
    fileSystems = lib.mkIf cfg.bootPartition {
      "/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
      };
    };

    swapDevices = lib.mkIf cfg.swapPart [
      {device = "/dev/disk/by-label/swap";}
    ];
  };
}
