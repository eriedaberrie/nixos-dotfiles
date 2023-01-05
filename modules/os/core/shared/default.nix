{ pkgs, ... }:

{
  imports = [
    ./nix.nix
    ./secrets.nix
    # inputs.nur.nixosModules.nur
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    tmp = {
      useTmpfs = true;
      tmpfsSize = "75%";
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.localBinInPath = true;

  security.sudo = {
    enable = true;
    package = pkgs.sudo.override {withInsults = true;};
    extraConfig = ''
      Defaults insults
    '';
  };

  programs = {
    command-not-found.enable = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
