{ pkgs, lib, config, ... }:

{
  imports = [
    ./traefik.nix
    ./dashdot.nix
    ./v8p.me.nix
    ./jellyfin.nix
  ];

  options.podman.enable = lib.mkEnableOption "podman";

  config = lib.mkIf config.podman.enable {
    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      oci-containers.backend = "podman";
    };

    systemd.targets."podman-root" = {
      unitConfig = {
        Description = "podman root target";
      };
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services."podman-traefik-network" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "${pkgs.podman}/bin/podman network rm -f traefik_network";
      };
      script = ''
        ${pkgs.podman}/bin/podman network inspect traefik_network || podman network create traefik_network
      '';
      partOf = [ "podman-root.target" ];
      wantedBy = [ "podman-root.target" ];
    };
  };
}
