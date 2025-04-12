{ pkgs, ... }:

{
  programs.vim = {
    plugins = with pkgs.vimPlugins; [
      coc-nvim
      gruvbox-nvim
      vim-nix
      auto-pairs
    ];
    extraConfig = ''
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
  };
}