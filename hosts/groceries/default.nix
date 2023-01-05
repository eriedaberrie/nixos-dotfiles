{ pkgs, username, ... }:

{
  imports = [
    ./services
    ./hardware-configuration.nix
  ];

  time.timeZone = "America/Los_Angeles";

  my = {
    cli.fish.enable = true;
    fs = {
      bootPartition = false;
      swapPart = false;
    };
  };

  boot = {
    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_scsi"
      "ahci"
      "sd_mod"
    ];

    kernelParams = [ "console=ttyS0,19200n8" ];
    kernelModules = [ "virtio_net" ];

    loader = {
      timeout = 10;
      grub = {
        enable = true;
        forceInstall = true;
        device = "nodev";
        extraConfig = ''
          serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
          terminal_input serial;
          terminal_output serial
        '';
      };
    };
  };

  networking = {
    usePredictableInterfaceNames = false;
    useDHCP = false;
    interfaces.eth0 = {
      useDHCP = true;
      tempAddress = "disabled";
    };
  };

  environment.systemPackages = with pkgs; [
    inetutils
    mtr
    sysstat

    nil
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  users.users.${username} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElnlmCCIRhwe7z/a4dpwNoPF65II8NsOHUWJIBdr2Rg errie@nix-laptop"
    ];
  };

  system.stateVersion = "23.05";
}
