{ lib, config, inputs, ... }: let
  cfg = config.podman.services."vaporii.net";
in {
  options.podman.services."vaporii.net" = {
    enable = lib.mkEnableOption "vaporii.net";
    https = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "whether to enable https with traefik";
    };
    domainName = lib.mkOption {
      type = lib.types.string;
      default = "vaporii.net";
      description = "domain name";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers."vaporii.net" = {
      imageFile = inputs."vaporii.net".packages.x86_64-linux.default;
      image = "vaporii.net";
      labels = {
        "traefik.enable" = if cfg.https then "true" else "false";
        "traefik.http.routers.vaporii.rule" = "Host(`${cfg.domainName}`)";
        "traefik.http.routers.vaporii.entrypoints" = "websecure";
        "traefik.http.routers.vaporii.certresolver" = "myresolver";
      };
      extraOptions = [
        "--network=traefik_network"
      ];
      dependsOn = [
        "traefik"
      ];
      # environmentFiles = [
      #   config.sops.secrets."containers/vaporii.net.env".path
      # ];
    };
  };
}
