{ lib, config, ... }: let
  cfg = config.podman.services.dashdot;
in {
  options.podman.services.dashdot = {
    enable = lib.mkEnableOption "dashdot";
    https = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "whether to enable https with traefik";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.dashdot = {
      image = "mauricenino/dashdot:latest";
      volumes = [
        "/:/mnt/host:ro"
      ];
      labels = {
        "traefik.enable" = if cfg.https then "true" else "false";
        "traefik.http.routers.dashdot.rule" = "Host(`dashdot.vaporii.net`)";
        "traefik.http.routers.dashdot.entrypoints" = "websecure";
        "traefik.http.routers.dashdot.tls.certresolver" = "myresolver";
      };
      extraOptions = [
        "--network=traefik_network"
      ];
      dependsOn = [
        "traefik"
      ];
    };
  };
}
