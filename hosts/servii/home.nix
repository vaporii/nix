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
  };

  bash.enable = true;
  git.enable = true;

  vim.enable = true;
  vim.nixHost = "servii";

  home.stateVersion = "24.11";
}
