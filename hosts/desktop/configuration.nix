{ pkgs, inputs, lib, system, config, ... }:

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

  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;

  nix.settings.download-buffer-size = 524288000;

  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
.      IFS=$'\n'
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

  networking.hostName = "desktop"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
    fcitx5.waylandFrontend = true;
    fcitx5.settings.inputMethod = {
      GroupOrder."0" = "Default";
      "Groups/0" = {
        Name = "Default";
        "Default Layout" = "us";
        DefaultIM = "keyboard-us";
      };
      "Groups/0/Items/0".Name = "keyboard-us";
      "Groups/0/Items/1".Name = "mozc";
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="346e", ATTRS{idProduct}=="0004", MODE="0666"
    SUBSYSTEM=="usb", MODE="0666"
  '';

  services.greetd = {
    enable = true;
    restart = false;
    settings = rec {
      initial_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --user-menu -t";
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

  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
  };

  programs.steam.enable = true;

  hardware.graphics.enable32Bit = true;
  hardware.graphics.enable = true;

  # nixpkgs.config.cudaSupport = true;
  # nixpkgs.config.cudaForwardCompat = true;

  services.xserver.xkb.layout = "us";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.flatpak.enable = true;
  services.libinput.enable = true;
  hardware.wooting.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # virtualisation.docker.enable = true;

  hardware.opentabletdriver.enable = true;

  environment.variables =
    let
      makePluginPath = format:
        (lib.makeSearchPath format [
          "$HOME/.nix-profile/lib"
          "/run/current-system/sw/lib"
          "/etc/profiles/per-user/$USER/lib"
        ])
        + ":$HOME/.${format}";
    in
    {
      DSSI_PATH = makePluginPath "dssi";
      LADSPA_PATH = makePluginPath "ladspa";
      LV2_PATH = makePluginPath "lv2";
      LXVST_PATH = makePluginPath "lxvst";
      VST_PATH = makePluginPath "vst";
      VST3_PATH = makePluginPath "vst3";
      XCURSOR_SIZE = "20";
    };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "steam"
      "steam-unwrapped"
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "wootility"
      "corefonts"
    ];

  nixpkgs.config.allowUnfree = true;

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  users.users.vaporii = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "input" "adbusers" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      hyfetch
      blender
      unzip
      gimp
      equibop
      prismlauncher
      audacity
      # lmms
      yabridge
      yabridgectl
      # freecad
      yabridge
      yabridgectl
      # boxflat
      kicad
      jetbrains.idea-oss
      gradle
      arduino-ide
      # cudatoolkit
      openjdk21
      olympus
      vesktop
      freecad
      alvr
    ];
    hashedPassword = "$y$j9T$h14SkfRLxr/uUwoJbEb35.$l9k5T4/xHp4h1V95l/OdaYjC8Sb4AFXpvkPaqYJKE97";
  };

  services.hardware.openrgb.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  programs.fuse.userAllowOther = true;
  home-manager = {
    extraSpecialArgs = { inherit inputs; inherit system; };

    users.vaporii = import ./home.nix;

    backupFileExtension = "backup1";
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.vaporii.shell = pkgs.zsh;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    wget
    git
    kitty
    ags
    grim
    egl-wayland
    android-tools
  ];

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  fonts.packages = with pkgs; [
    twitter-color-emoji
    nerd-fonts.caskaydia-mono
    noto-fonts
    noto-fonts-cjk-sans
    corefonts
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}


