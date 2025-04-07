{ pkgs, inputs, ... }:

{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    configDir = ./ags;
    extraPackages = with pkgs; [
      inputs.ags.packages.${pkgs.system}.battery
      fzf
    ];
  };
}
