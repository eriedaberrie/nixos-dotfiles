{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.my.graphical.emacs;
in {
  options.my.graphical.emacs = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable (let
    inherit (inputs.emacs-overlay.overlays.package null pkgs) emacsPackagesFor;
    extraEpkgsMap = epkgs: extraEpkgList: map (extraEpkg: extraEpkg epkgs) extraEpkgList;
    emacs-everywhere = epkgs: epkgs.trivialBuild rec {
      pname = "emacs-everywhere";
      version = "69b46d703ad9e263325be3de98da3d24699121a3";
      src = pkgs.fetchFromGitHub {
        owner = "eriedaberrie";
        repo = pname;
        rev = version;
        hash = "sha256-d3eGJ+4ShTIHcjZQDK14dEmapNOv8RDrtoy9LoFSe5Q=";
      };
    };
    org-modern-indent = epkgs: epkgs.trivialBuild rec {
      pname = "org-modern-indent";
      version = "c5a50f302dc1053d5b498e0ea2bc0ee233e8e1b8";
      src = pkgs.fetchFromGitHub {
        owner = "jdtsmith";
        repo = pname;
        rev = version;
        hash = "sha256-6ne9rIaMZrW3by47/jsecaakbtm8yHsgyWhoVCrUCAw=";
      };
      propagatedUserEnvPkgs = with epkgs; [ compat ];
      buildInputs = propagatedUserEnvPkgs;
    };
    extraPackages = epkgs: with epkgs; [
      f
      dash
      undo-fu
      meow
      avy
      puni
      ace-window
      goggles
      dtrt-indent
      aggressive-indent
      rainbow-delimiters
      highlight-indent-guides
      which-key
      eglot-java
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
      minions
      dirvish
      persp-mode
      pdf-tools
      engrave-faces
      org-modern
      djvu
      nov
      org-pdftools
      org-alert
      editorconfig
      envrc
      sly
      sly-asdf
      sly-named-readtables
      racket-mode
      lua-mode
      nix-mode
      markdown-mode
      csv-mode
      meson-mode
      spell-fu
      minimap
      magit
      forge
      vterm
      mpv
      lingva
      mastodon
      circe
      circe-notifications
      elfeed
      xkcd
      page-break-lines
      hl-todo
      ligature
      gruvbox-theme
      catppuccin-theme
      solaire-mode
      with-editor
      nyan-mode
      org-msg
      treesit-grammars.with-all-grammars
    ] ++ extraEpkgsMap epkgs [
      emacs-everywhere
      org-modern-indent
    ];
    alternateEmacsclient = pkgs.writeShellScript "alternate-emacsclient" ''
      ${pkgs.systemd}/bin/systemctl --user start emacs.service && \
        exec ${config.programs.emacs.finalPackage}/bin/emacsclient -c -a "" "$@"
    '';
  in {
    programs.emacs = {
      enable = true;
      package = (emacsPackagesFor pkgs.emacs29-pgtk).emacsWithPackages extraPackages;
    };
    services.emacs = {
      enable = true;
      startWithUserSession = "graphical";
    };
    home = {
      sessionVariables.ALTERNATE_EDITOR = alternateEmacsclient;
      packages = with pkgs; [
        clang-tools
        nil
        nodePackages.typescript-language-server
        emacs-all-the-icons-fonts
        (aspellWithDicts (ds: with ds; [ en ]))
        imagemagick
        (texlive.combine {
          inherit (texlive) scheme-basic
            dvisvgm dvipng # Preview and export as html
            wrapfig amsmath ulem hyperref capt-of
            # Export code with engraved backend
            fvextra etoolbox fancyvrb upquote lineno
            tcolorbox pgf environ pdfcol
            xcolor float
            nopageno;
        })
        pandoc
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
        exec = "${config.programs.emacs.finalPackage}/bin/emacsclient -a ${alternateEmacsclient} -c %F";
        genericName = "Text Editor";
        comment = "Edit text";
        mimeType = ["text/english" "text/plain" ];
        categories = [ "Development" "TextEditor" ];
        startupNotify = true;
        settings.StartupWMClass = "Emacs";
        actions = {
          new-window = {inherit exec;};
          new-instance.exec = "${config.programs.emacs.finalPackage}/bin/emacs %F";
        };
      };
      emacsclient-mail = extendDefault rec {
        name = "Emacs (Mail, Client)";
        exec = (pkgs.writeShellScript "emacsclient-mail" ''
          u=''${1//\\/\\\\}
          u=''${u//\"/\\\"}
          exec ${config.programs.emacs.finalPackage}/bin/emacsclient -a ${alternateEmacsclient} -c \
            --eval "(message-mailto \"$u\")"
        '') + " %u";
        comment = "GNU Emacs is an extensible, customizable text editor - and more";
        mimeType = [ "x-scheme-handler/mailto" ];
        noDisplay = true;
        actions = {
          new-window = {inherit exec;};
          new-instance.exec = "${config.programs.emacs.finalPackage}/bin/emacs -f message-mailto %u";
        };
      };
    };
  });
}
