{ pkgs, config, lib, ... }:

let
  cfg = config.my.cli.applications;
in {
  options.my.cli.applications = {
    enable = lib.mkEnableOption null // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vim
      wget
      gnumake
      findutils
      psmisc
      file
      moreutils
      pciutils
      p7zip
      unzip
      unar
      bat
      fd
      ripgrep
      exa
    ];

    programs = {
      git.enable = true;
      htop.enable = true;
    };
  };
}
