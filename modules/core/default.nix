{ self, inputs, pkgs, lib, ... }:

{
  imports = [
    ./nix
    ./secrets.nix
    ./security.nix
    # inputs.nur.nixosModules.nur
    inputs.hyprland.nixosModules.default
    inputs.ragenix.nixosModules.age
    inputs.nix-index-database.nixosModules.nix-index
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 0;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    tmpOnTmpfs = true;
  };

  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        scanRandMacAddress = false;
      };
    };
  };

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Stop auto suspending
  services.logind.lidSwitch = "ignore";

  # Printing
  services = {
    printing = {
      enable = true;
      cups-pdf.enable = true;
      drivers = [ pkgs.gutenprint ];
    };
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General.Enable = "Source,Sink,Media,Socket";
    };
  };
  services.blueman.enable = true;

  # Swap caps lock and escape, CTRL -> BS on press
  services.interception-tools = {
    enable = true;
    plugins = with pkgs.interception-tools-plugins; [ caps2esc dual-function-keys ];
    udevmonConfig = let
      inherit (pkgs.interception-tools-plugins) caps2esc dual-function-keys;
      _ = lib.getExe;
      __ = x: "${pkgs.interception-tools}/bin/${x}";
      dffConf = pkgs.writeText "dual-function-keys.yaml" ''
        TIMING:
          TAP_MILLISEC: 150
          DOUBLE_TAP_MILLISEC: 0
        MAPPINGS:
          - KEY: KEY_LEFTSHIFT
            TAP: KEY_BACKSPACE
            HOLD: KEY_LEFTSHIFT
          - KEY: KEY_LEFTALT
            TAP: [KEY_LEFTCTRL, KEY_BACKSPACE]
            HOLD: KEY_LEFTALT
      '';
    in ''
      - JOB: "${__ "intercept"} -g $DEVNODE | ${_ dual-function-keys} -c ${dffConf} | ${_ caps2esc} | ${__ "uinput"} -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC, KEY_LEFTSHIFT, KEY_LEFTALT]
    '';
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.errie = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
        "networkmanager"
        "disk"
        "input"
      ];
    };
  };

  environment = {
    localBinInPath = true;
    pathsToLink = [ "/share/zsh" "/share/bash-completion" ];
    systemPackages = with pkgs; [
      vim
      wget
      cmake
      meson
      gnumake
      libtool
      findutils
      psmisc
      file
      moreutils
      pciutils
      brightnessctl
      acpi
      intel-gpu-tools
      powertop
      gcc
      p7zip
      unzip
      bat
      fd
      ripgrep
      exa
      dos2unix
      jq
      jaq
      imagemagick
      ffmpeg
      pulsemixer
      appimage-run
      inputs.ragenix.packages.${system}.default
      inputs.nix-alien.packages.${system}.default
    ];
  };

  # Geoclue2 location
  services.geoclue2.enable = true;
  location.provider = "geoclue2";
  services.localtimed.enable = true;

  programs = {
    zsh.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
    nix-index = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
    };
    git = {
      enable = true;
      package = pkgs.gitFull;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };

  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
