{ pkgs, lib, ... }:

let
  LSP_USE_PLISTS = "true";
  # This is fine since I have to build all of them myself anyways
  epkgsMap = epkgList: map (epkg: epkg.overrideAttrs (_: {inherit LSP_USE_PLISTS;})) epkgList;
  emacs-everywhere = epkgs: epkgs.trivialBuild rec {
    pname = "emacs-everywhere";
    version = "1c51d7e0b5c17c14fb970df59069fcdb0c86c2a3";
    src = pkgs.fetchFromGitHub {
      owner = "eriedaberrie";
      repo = pname;
      rev = version;
      sha256 = "0nykdvvk4hraaabn476i9dsxgf3bq8dcilqvspj1c6jsbkjsxp3h";
    };
  };
  emacsPackage = with pkgs; ((emacsPackagesFor emacsPgtk).emacsWithPackages (
    epkgs: epkgsMap (with epkgs; [
      f
      dash
      undo-fu
      meow
      puni
      ace-window
      goggles
      dtrt-indent
      aggressive-indent
      rainbow-delimiters
      which-key
      lsp-mode
      lsp-java
      lsp-ui
      lsp-treemacs
      dap-mode
      yasnippet
      yasnippet-snippets
      consult
      consult-yasnippet
      embark
      embark-consult
      orderless
      marginalia
      vertico
      corfu
      cape
      all-the-icons
      all-the-icons-completion
      treemacs
      treemacs-all-the-icons
      doom-modeline
      dirvish
      pdf-tools
      wc-mode
      org-superstar
      org-pdftools
      editorconfig
      envrc
      slime
      nix-mode
      markdown-mode
      meson-mode
      spell-fu
      minimap
      magit
      forge
      vterm
      elfeed
      xkcd
      page-break-lines
      hl-todo
      ligature
      gruvbox-theme
      catppuccin-theme
      solaire-mode
      with-editor
    ]) ++ [
      (emacs-everywhere epkgs)
    ]
  ));
in {
  programs.emacs = {
    enable = true;
    package = emacsPackage;
  };
  home = {
    sessionVariables = {
      inherit LSP_USE_PLISTS;
      ALTERNATE_EDITOR = "";
    };
    packages = with pkgs; [
      mu
      emacs-all-the-icons-fonts
      (aspellWithDicts (ds: with ds; [ en ]))
      (texlive.combine {
        inherit (texlive) scheme-basic
          dvisvgm dvipng # preview and export as html
          wrapfig amsmath ulem hyperref capt-of;
      })
      pandoc
      vscode-extensions.llvm-org.lldb-vscode
      gdb
    ];
    file.".clang-format".text = ''
      ---
      BasedOnStyle: LLVM
      IndentWidth: 4
      TabWidth: 4
      UseTab: Always
      ...
    '';
  };
  xdg.desktopEntries = let
    extendDefault = attrs: lib.recursiveUpdate {
      icon = "emacs";
      terminal = false;
      type = "Application";
      settings.Keywords = "emacsclient;";
      actions = {
        new-window.name = "New Window";
        new-instance.name = "New Instance";
      };
    } attrs;
  in {
    emacsclient = extendDefault rec {
      name = "Emacs (Client)";
      exec = "${emacsPackage}/bin/emacsclient --create-frame --alternate-editor= %F";
      genericName = "Text Editor";
      comment = "Edit text";
      mimeType = ["text/english" "text/plain" ];
      categories = [ "Development" "TextEditor" ];
      startupNotify = true;
      settings.StartupWMClass = "Emacs";
      actions = {
        new-window = {inherit exec;};
        new-instance.exec = "${emacsPackage}/bin/emacs %F";
      };
    };
    emacsclient-mail = extendDefault rec {
      name = "Emacs (Mail, Client)";
      exec = (pkgs.writeShellScript "emacsclient-mail" ''
        u=''${1//\\/\\\\}
        u=''${u//\"/\\\"}
        exec ${emacsPackage}/bin/emacsclient --alternate-editor= --create-frame \
          --eval "(message-mailto \"$u\")"
      '') + " %u";
      comment = "GNU Emacs is an extensible, customizable text editor - and more";
      mimeType = [ "x-scheme-handler/mailto" ];
      noDisplay = true;
      actions = {
        new-window = {inherit exec;};
        new-instance.exec = "${emacsPackage}/bin/emacs -f message-mailto %u";
      };
    };
  };
}
