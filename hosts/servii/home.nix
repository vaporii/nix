{ inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
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

  home.stateVersion = "24.11";
}
