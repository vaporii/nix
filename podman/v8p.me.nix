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
      imageFile = inputs."v8p.me".packages.x86_64-linux.default;
      image = "v8p.me";
      volumes = [
        "${cfg.storage}:/var/lib/v8p.me"
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
      environment = {
        "DB_PATH" = "/var/lib/v8p.me/files.db";
        "FILES_DIR" = "/var/lib/v8p.me/files";
        "ALIAS_LENGTH" = "6";
        "BODY_SIZE_LIMIT" = "10G";
        "PORT" = "3000";
        "ORIGIN" = "https://v8p.me";
      };
    };
  };
}
