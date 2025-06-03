{ lib, config, pkgs, ... }:

{
  options.rsync.enable = lib.mkEnableOption "rsync";

  config = lib.mkIf config.rsync.enable {
    systemd.user.services.rsync = {
      Unit = {
        Description = "push Persist to server";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "sync-files" ''
          #!/run/current-system/sw/bin/bash
          ${pkgs.inotify-tools}/bin/inotifywait -m -e create -e delete -r ~/Persist |
          while read path action file; do
            echo "The file '$file' at '$path' was $action"
            ${pkgs.rsync}/bin/rsync -avz --protocol=31 --delete -e "${pkgs.openssh}/bin/ssh -i ~/.ssh/v8p_ed25519" ~/Persist vaporii@vaporii.net:~/back
          done
        ''}";
      };
    };
  };
}
