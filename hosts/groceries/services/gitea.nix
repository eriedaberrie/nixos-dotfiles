{ ... }:

{
  services = {
    gitea = {
      enable = true;
      lfs.enable = true;
      settings = {
        server = {
          ROOT_URL = "https://git.eriedaberrie.me/";
        };
        service = {
          DISABLE_REGISTRATION = true;
        };
      };
    };

    nginx.virtualHosts."git.eriedaberrie.me" = {
      forceSSL = true;
      useACMEHost = "eriedaberrie.me";
      locations."/".proxyPass = "http://localhost:3000";
    };
  };

  security.acme.certs."eriedaberrie.me".extraDomainNames = [ "git.eriedaberrie.me" ];
}
