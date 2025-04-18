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

  git.enable = true;
  bash.enable = true;

  vim.enable = true;
  vim.nixHost = "servii";
}
