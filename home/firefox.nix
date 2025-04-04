{ pkgs, ... }:

{
  programs.firefox = {
    profiles.default = {
      extensions = {
        # packages = with pkgs.nur.repos
      };
    };
  };
}
