{ lib, config, ... }: let
  cfg = config.podman.services.pufferpanel;
in {
  options.podman.services.pufferpanel = {
    enable = lib.mkEnableOption "pufferpanel";
    storage = {
      data = lib.mkOption {
        type = lib.types.str;
        description = "string volume name or path where data is stored";
        default = "pufferpanel-data";
      };
      config = lib.mkOption {
        type = lib.types.str;
        description = "string volume name or path where config is stored";
        default = "pufferpanel-config";
      };
    };
  };

config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.pufferpanel = {
      image = "pufferpanel/pufferpanel:latest";
      volumes = [
        "${cfg.storage.data}:/data"
        "${cfg.storage.config}:/config"
      ];
      extraOptions = [
        "--network=host"
      ];
      dependsOn = [
        "traefik"
      ];
      ports = [
        "25565:25565"
        "5657:5657"
      ];
    };
  };
}
