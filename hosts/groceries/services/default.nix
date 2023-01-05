{ config, ... }:

{
  imports = [
    ./gitea.nix
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    virtualHosts = {
      "eriedaberrie.me" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        serverAliases = [ "www.eriedaberrie.me" ];
        locations."/".proxyPass = "http://localhost:8080";
      };

      "iclean.eriedaberrie.me" = {
        forceSSL = true;
        useACMEHost = "eriedaberrie.me";
        locations."/".proxyPass = "http://localhost:12345";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "eriedaberrie@gmail.com";
    certs = {
      "eriedaberrie.me" = {
        dnsProvider = "porkbun";
        credentialsFile = config.age.secrets.porkbun-auth.path;
        extraDomainNames = [
          "iclean.eriedaberrie.me"
        ];
      };
    };
  };
}
