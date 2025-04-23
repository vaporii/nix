{ lib, config, ... }: let
  cfg = config.podman.services.jellyfin;
in {
  options.podman.services.jellyfin = {
    enable = lib.mkEnableOption "jellyfin";
    https = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "whether to enable https with traefik";
    };
    storage = {
      media = lib.mkOption {
        type = lib.types.str;
        description = "string volume name or path where media is stored";
        default = "~/Persist/media";
      };
      cache = lib.mkOption {
        type = lib.types.str;
        description = "string volume name or path where cache is stored";
        default = "jellyfin-cache";
      };
      config = lib.mkOption {
        type = lib.types.str;
        description = "string volume name or path where config is stored";
        default = "jellyfin-config";
      };
    };
  };

config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.jellyfin = {
      image = "jellyfin/jellyfin:latest";
      volumes = [
        "${cfg.storage.media}:/media"
        "${cfg.storage.config}:/config"
        "${cfg.storage.cache}:/cache"
      ];
      labels = {
        "traefik.enable" = if cfg.https then "true" else "false";
        "traefik.http.routers.jellyfin.rule" = "Host(`jellyfin.vaporii.net`)";
        "traefik.http.routers.jellyfin.entrypoints" = "websecure";
        "traefik.http.routers.jellyfin.tls.certresolver" = "myresolver";
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
