{ config, lib, username, ... }:

let
  cfg = config.my.fs;
in {
  config = lib.mkIf (cfg.type == "btrfs") {
    fileSystems = builtins.mapAttrs (_: options: {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "noatime" "space_cache=v2" "compress=zstd:9" ] ++ options;
    }) ({
      "/" = [ "subvol=root" ];
      "/nix" = [ "subvol=nix" ];
    } // lib.optionalAttrs cfg.snapshots ({
      "/home" = [ "subvol=home" ];
      "/home/${username}/.cache" = [ "subvol=misc/cache" ];
    } // lib.optionalAttrs config.programs.steam.enable {
      "/home/${username}/.local/share/Steam" = [ "subvol=misc/steam" ];
    }));

    services = {
      fstrim.enable = true;
      snapper = lib.mkIf cfg.snapshots {
        configs.home = {
          SUBVOLUME = "/home";
          ALLOW_USERS = [ username ];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
        };
      };
    };
  };
}
