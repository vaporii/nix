{ pkgs, inputs, lib, system, ... }:

{
  imports =
    [
      (import ./disko.nix { device = "/dev/sda"; })
      ./hardware-configuration.nix
      ../../podman
    ];
  
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
      IFS=$'\n'
      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/btrfs_tmp/$i"
      done
      btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
      delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  networking.hostName = "brunswick";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      hyfetch
      unzip
    ];
    hashedPassword = "$y$j9T$h14SkfRLxr/uUwoJbEb35.$l9k5T4/xHp4h1V95l/OdaYjC8Sb4AFXpvkPaqYJKE97";
  };

  programs.fuse.userAllowOther = true;
  home-manager = {
    extraSpecialArgs = { inherit inputs system; };
    users.admin = import ./home.nix;
    backupFileExtension = "backup";
  };

  podman = {
    enable = true;
    services = {
      # turn off https temporarily
      traefik.enable = false;
      dashdot = {
        enable = false;
        https = false;
      };
      "v8p.me" = {
        enable = false;
        https = false;
      };
      jellyfin = {
        enable = false;
        https = false;
      };
      "vaporii.net" = {
        enable = false;
        https = false;
      };
      pufferpanel.enable = true;
    };
  };

  services.vscode-server.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    podman-compose
    podman-tui
  ];

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  system.stateVersion = "24.11"; # Did you read the comment?
}

