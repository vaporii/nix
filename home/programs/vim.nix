{ pkgs, ... }:

{
  programs.nixvim = {
    options = {
      autoindent = true;
      smartindent = true;
      expandtab = true;

      tabstop = 2;
      shiftwidth = 2;

      backspace = "indent,eol,start";
      number = true;
      relativenumber = true;
    };
    
    colorschemes.gruvbox.enable = true;

    plugins = {
      lightline.enable = true;
      treesitter.enable = true;
      auto-pairs.enable = true;
      oil.enable = true;
      telescope.enable = true;
      
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
        };
      };
      nvim-cmp = {
        enable = true;
        autoEnableSources = true;
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };
    };
  };
}