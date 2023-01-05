{ config, lib, ... }:

let
  cfg = config.my.fs;
in {
  config = lib.mkIf (cfg.type == "ext4") {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
        options = [ "noatime" ];
      };
    };
  };
}
