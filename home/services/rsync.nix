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
          #!/bin/sh
          ${pkgs.inotify-tools}/bin/inotifywait -m -e create -e delete -r ~/Persist |
          while read path action file; do
            echo "The file '$file' at '$path' was $action"
            ${pkgs.rsync}/bin/rsync -avzu --protocol=31 -e "${pkgs.openssh}/bin/ssh -p 25567" ~/Persist vaporii@vaporii.net:~/back
          done
        ''}";
      };
    };

    systemd.user.services.rsync-pull = {
      Unit = {
        Description = "pull Persist from server";
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "pull-files" ''
          #!/bin/sh
          ${pkgs.rsync}/bin/rsync -avzu --protocol=31 -e "${pkgs.openssh}/bin/ssh -p 25567" vaporii@vaporii.net:~/back/Persist/ ~/Persist
        ''}";
      };
    };

    systemd.user.timers.rsync-pull-timer = {
      Unit = {
        Description = "Periodic pull from server";
      };
      Timer = {
        OnBootSec = "5min";
        OnUnitActiveSec = "1h";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
