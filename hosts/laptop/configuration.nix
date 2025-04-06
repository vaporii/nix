{ pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

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
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "vaporii";
      };
      default_session = initial_session;
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.xserver.xkb.layout = "us";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.users.vaporii = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      hyfetch
      blender
      unzip
      gimp
      hyprpaper
    ];
    hashedPassword = "$y$j9T$h14SkfRLxr/uUwoJbEb35.$l9k5T4/xHp4h1V95l/OdaYjC8Sb4AFXpvkPaqYJKE97";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };

    users.vaporii = import ./home.nix;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    ((vim_configurable.override { }).customize{
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix auto-pairs ];
        opt = [];
      };
      vimrcConfig.customRC = ''
        set autoindent
        set smartindent
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set backspace=indent,eol,start
        syntax on
        set number
        set relativenumber
      '';
    })
    wget
    git
    kitty
    ags
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-mono
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}

