{ pkgs, config, lib, self, ... }:

let
  cfg = config.my.fetch;
in {
  options.my.fetch = {
    fastfetch.enable = lib.mkEnableOption null;
    neofetch.enable = lib.mkEnableOption null;
    others.enable = lib.mkEnableOption null;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.fastfetch.enable {
      home.packages = [
        (self.packages.${pkgs.system}.fastfetch.override {
          extraFlashfetchConf = ''
            // I do not care about the versions, and they introduce a "significant" slowdown
            instance.config.shellVersion = false;
            instance.config.terminalVersion = false;
    
            ffPrintTitle(&instance);
            ffPrintSeparator(&instance);
            ffPrintOS(&instance);
            ffPrintHost(&instance);
            ffPrintKernel(&instance);
            ffPrintUptime(&instance);
            ffPrintShell(&instance);
            ffPrintDisplay(&instance);
            ffPrintWM(&instance);
            ffPrintTheme(&instance);
            ffPrintIcons(&instance);
            ffPrintFont(&instance);
            ffPrintCursor(&instance);
            ffPrintTerminal(&instance);
            ffPrintTerminalFont(&instance);
            ffPrintCPU(&instance);
            ffPrintGPU(&instance);
            ffPrintMemory(&instance);
            ffPrintDisk(&instance);
            ffPrintBattery(&instance);
            ffPrintLocale(&instance);
            ffPrintBreak(&instance);
            ffPrintColors(&instance);
          '';
        })
      ];
    })

    (lib.mkIf cfg.neofetch.enable {
      home.packages = [ pkgs.neofetch ];
      xdg.configFile = {
        "neofetch/config.conf".text = ''
          print_info() {
            info title
            info underline
            info "OS" distro
            info "Host" model
            info "Kernel" kernel
            info "Uptime" uptime
            info "Shell" shell
            info "Resolution" resolution
            info "DE" de
            info "Theme" theme
            info "Icons" icons
            info "Terminal" term
            info "Terminal Font" term_font
            info "CPU" cpu
            info "GPU" gpu
            info "Memory" memory
            info cols
          }
          memory_percent="on"
          shell_path="on"
          speed_shorthand="off"
        '';
      };
    })

    (lib.mkIf cfg.others.enable {
      home.packages = with pkgs; [
        pfetch
        nitch
        (uwufetch.overrideAttrs (old: {
          preBuild = old.preBuild or "" + ''
            mkdir -p $out/include
          '';
        }))
      ];
    })
  ];
}
