{ lib, config, ... }: let
  cfg = config.services.traefik;
in {
  options.services.traefik = {
    enable = lib.mkEnableOption "traefik";
    storage = lib.mkOption {
      type = lib.types.oneOf [ lib.types.path lib.types.str ];
      description = "string volume name or path to store traefik data";
      default = "traefik-data";
    };
    acme = {
      email = lib.mkOption {
        type = lib.types.str;
        description = "email for acme";
        default = "phi548182@gmail.com";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.traefik = {
      image = "traefik";
      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
        "${config.traefik.storage}:/traefikconfig:rw"
      ];
      ports = [
        "80:80/tcp"
        "443:443/tcp"
      ];
      labels = {
        "serverstransport.insecureskipverify" = "true";
        "api.insecure" = "true";
        "providers.docker" = "true";
        "providers.docker.exposedbydefault" = "false";
        "entrypoints.websecure.address" = ":443";
        "entrypoints.websecure.transport.respondingTimeouts.readTimeout" = "10m";
        "entrypoints.web.address" = ":80";
        "entrypoints.web.http.redirections.entryPoint.to" = "websecure";
        "entrypoints.web.http.redirections.entryPoint.scheme" = "https";
        "entrypoints.web.http.redirections.entryPoint.permanent" = "true";
        "certificatesresolvers.myresolver.acme.tlschallenge" = "true";
        "providers.file.directory" = "/traefikconfig/config";
        "providers.file.watch" = "true";
        "certificatesresolvers.myresolver.acme.email" = cfg.acme.email;
        "certificatesresolvers.myresolver.acme.storage" = "/traefikconfig/le/acme.json";
      };
    };
  };
}
