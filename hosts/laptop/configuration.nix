{ pkgs, inputs, lib, system, ... }:

{
  imports =
    [
      (import ./disko.nix { device = "/dev/nvme0n1"; })
      ./hardware-configuration.nix
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
  boot.loader.timeout = 5;
  boot.loader.grub.extraEntries = ''
    menuentry "asciiquarium" {
      insmod lvm
      insmod ext2
      insmod btrfs

      set root=(lvm/root_vg-root)
      loopback loop (lvm/root_vg-root)/persist/home/Persist/projects/os/asciiquarium-os/temp-asciiquarium.img

      linux (loop)/boot/vmlinuz-lts root=/dev/mapper/root_vg-root
      initrd (loop)/boot/initramfs-lts
      boot
    }
  '';

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

  networking.hostName = "laptop"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.greetd = {
    enable = true;
    restart = false;
    settings = rec {
      initial_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --user-menu -t";
        # command = "${pkgs.hyprland}/bin/Hyprland";
        user = "vaporii";
      };
      default_session = initial_session;
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.steam.enable = true;

  services.xserver.xkb.layout = "us";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # systemd.services."rsync" = {
  #   enable = true;
  #   wantedBy = [ "network-online.target" ];
  #   script = /* bash */ ''
  #     while ${pkgs.inotify-tools}/bin/inotifywait -e create -e delete -r ~/Persist; do
  #       ${pkgs.rsync}/bin/rsync -avz --protocol=31 --delete -e "${pkgs.openssh}/bin/ssh -i /home/vaporii/.ssh/v8p_ed25519" /home/vaporii/Persist vaporii@vaporii.net:~/back || exit 1
  #     done
  #   '';
  #   serviceConfig = {
  #     Type = "simple";
  #     RestartSec = 5;
  #     User = "vaporii";
  #   };
  # };

  services.libinput.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "steam"
      "steam-unwrapped"
      "wootility"
    ];

  users.users.vaporii = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "input" "dialout" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      hyfetch
      blender
      unzip
      gimp
      discordchatexporter-cli
      eclipses.eclipse-java
      qemu_kvm
      wootility
      puredata
    ];
    hashedPassword = "$y$j9T$h14SkfRLxr/uUwoJbEb35.$l9k5T4/xHp4h1V95l/OdaYjC8Sb4AFXpvkPaqYJKE97";
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", MODE:="0660", GROUP="input", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", MODE:="0660", GROUP="input", TAG+="uaccess" 
  '';

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  programs.fuse.userAllowOther = true;
  home-manager = {
    extraSpecialArgs = { inherit inputs; inherit system; };

    users.vaporii = import ./home.nix;

    backupFileExtension = "backup1";
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.variables.XCURSOR_SIZE = "20";

  environment.systemPackages = with pkgs; [
    # ((vim_configurable.override { }).customize{
    #   name = "vim";
    #   vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
    #     start = [ vim-nix auto-pairs ];
    #     opt = [];
    #   };
    #   vimrcConfig.customRC = ''
    #     set autoindent
    #     set smartindent
    #     set tabstop=2
    #     set shiftwidth=2
    #     set expandtab
    #     set backspace=indent,eol,start
    #     syntax on
    #     set number
    #     set relativenumber
    #   '';
    # })
    wget
    git
    kitty
    ags
    grim
  ];

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  fonts.packages = with pkgs; [
    twitter-color-emoji
    nerd-fonts.caskaydia-mono
    noto-fonts
    noto-fonts-cjk-sans
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}


