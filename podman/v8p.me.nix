{ lib, config, inputs, ... }: let
  cfg = config.podman.services."v8p.me";
in {
  options.podman.services."v8p.me" = {
    enable = lib.mkEnableOption "v8p.me";
    https = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "whether to enable https with traefik";
    };
    storage = lib.mkOption {
      type = lib.types.oneOf [ lib.types.path lib.types.str ];
      description = "string volume name or path to store files and data";
      default = "v8p.me-data";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers."v8p.me" = {
      image = inputs."v8p.me".packages.x86_64-linux.default;
      volumes = [
        # "${cfg.storage}:"
      ];
      labels = {
        "traefik.enable" = if cfg.https then "true" else "false";
        "traefik.http.routers.v8p.rule" = "Host(`v8p.me`)";
        "traefik.http.routers.v8p.entrypoints" = "websecure";
        "traefik.http.routers.v8p.tls.certresolver" = "myresolver";
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
