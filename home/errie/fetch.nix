{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neofetch
    pfetch
    nitch
    (uwufetch.overrideAttrs (old: {
      preBuild = old.preBuild or "" + ''
        mkdir -p $out/include
     '';
    }))
  ];

  xdg.configFile = {
    "neofetch/config.conf".text = ''
      print_info() {
        info title
        info underline
        info "OS" distro
        info "Host" model
        info "Kernel" kernel
        info "Uptime" uptime
        info "Packages" packages
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
}
