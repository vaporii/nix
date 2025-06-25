{ inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    ../../home
  ];

  home.persistence."/persist/home" = {
    directories = [
      "Persist"
      ".ssh"
    ];
    files = [
      ".bash_history"
    ];
    allowOther = true;
  };

  vim.enable = true;
  vim.nixHost = "brunswick";

  git.enable = true;

  home.stateVersion = "24.11";
}
