{ pkgs, config, lib, osConfig, ... }:

let
  cfg = config.my.email;
in {
  options.my.email = {
    enable = lib.mkEnableOption null;
    git.enable = lib.mkEnableOption null // {
      default = true;
    };
    emacs.enable = lib.mkEnableOption null // {
      default = config.my.git.enable;
    };
  };

  config = lib.mkIf cfg.enable (let
    emailJson = osConfig.age.secrets.email.path;
    anyConfigCmd = delim: t: k:
      "${pkgs.jaq}/bin/jaq -r ${delim}.${t}.${k}${delim} ${emailJson}";
  in lib.mkMerge [
    (lib.mkIf cfg.emacs.enable {
      accounts.email = {
        maildirBasePath = "Mail";
        accounts = builtins.mapAttrs (type: address: {
          inherit address;
          passwordCommand = anyConfigCmd "" type "password";
          primary = type == "personal";
          flavor = "gmail.com";
          smtp.tls.useStartTls = true;
          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
          };
          mu.enable = true;
          imapnotify = let
            mbsync = "${config.programs.mbsync.package}/bin/mbsync";
            mu = "${pkgs.mu}/bin/mu";
          in {
            enable = true;
            boxes = [ "Inbox" ];
            onNotify = "${mbsync} ${type} && ${mu} index";
            onNotifyPost = let
              notify-send = "${pkgs.libnotify}/bin/notify-send";
              muFindEscape = f: let
                sed = "${pkgs.gnused}/bin/sed";
              in "${mu} find \"l:$FILE\" -f ${f}"
                 + " | ${sed} 's/</\\&lt;/g'"
                 + " | ${sed} 's/>/\\&gt;/g'";
            in pkgs.writeScript "inbox-notify-latest-${type}" ''
            FILE="$(${mu} find "m:/${type}/Inbox" -z -s d -n 1 -f l)"
            exec ${notify-send} -i mail-unread-new \
              "[${address}] $(${muFindEscape "s"})" \
              "from: $(${muFindEscape "f"})"
          '';
            extraConfig.wait = 10;
          };
        }) {
          personal = "erlic006@gmail.com";
          other = "eriedaberrie@gmail.com";
        };
      };
      programs = {
        mbsync.enable = true;
        mu.enable = true;
      };
      services.imapnotify.enable = true;
      home.sessionVariables.MAILDIR = config.accounts.email.maildirBasePath;
    })

    (lib.mkIf cfg.git.enable (let
      gitSetEmail = pkgs.writeShellScriptBin "git-set-email" (let
        git = "${config.programs.git.package}/bin/git";
        gitConfRep = "${git} config --replace-all --local";
      in ''
        ${git} rev-parse --is-inside-work-tree > /dev/null || exit 1
        if [ -z "$1" ]; then
          declare -a keys=("user.name"
                           "user.email"
                           "sendemail.from"
                           "sendemail.smtpUser"
                           "sendemail.smtpPass"
                           "sendemail.smtpEncryption"
                           "sendemail.smtpServer"
                           "sendemail.smtpServerPort"
                           "sendemail.smtpSslCertPath")
          for key in "''${keys[@]}"; do
            ${git} config --unset-all --local "$key"
          done
        else
          [ "$(${pkgs.jaq}/bin/jaq "has(\"$1\")" ${emailJson})" = true ] || exit 1
          ${gitConfRep} 'user.name' "$(${anyConfigCmd "\"" "$1" "name"})"
          ${gitConfRep} 'user.email' "$(${anyConfigCmd "\"" "$1" "address"})"
          ${gitConfRep} 'sendemail.smtpPass' "$(${anyConfigCmd "\"" "$1" "password"})"
          declare -a keys=("from"
                           "smtpEncryption"
                           "smtpServer"
                           "smtpServerPort"
                           "smtpSslCertPath"
                           "smtpUser")
          for key in "''${keys[@]}"; do
            ${gitConfRep} "sendemail.$key" \
              "$(${git} config --get --global "sendemail.$1.$key")"
          done
        fi
      '');
    in {
      home.packages = [ gitSetEmail];
    }))
  ]);
}
