{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xdg-utils
    gdb
    (python311.withPackages (p: with p; [
      numpy
      pandas
      requests
      pillow
      yt-dlp
      tkinter
    ]))
    (ruby_3_1.withPackages (r: with r; [
      solargraph
      ruby-vips
    ]))
    nodejs-16_x
    sbcl
    lispPackages.quicklisp
    pyright
    sumneko-lua-language-server
    clang-tools
    rust-analyzer
    lazygit
    fortune
    neo-cowsay
    lolcat
    ranger
    nixfmt
    libnotify
    pavucontrol
    networkmanagerapplet
    fuzzel
    imv
    (symlinkJoin {
      name = "neovide-wrapped";
      paths = [ neovide ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/neovide \
        --set WINIT_UNIX_BACKEND x11 \
        --set NEOVIDE_MULTIGRID true
      '';
    })
    gimp
    inkscape
    xfce.thunar
    libqalculate
    qalculate-gtk
    libreoffice
    hunspell
    hunspellDicts.en-us
    remmina
  ];
}
