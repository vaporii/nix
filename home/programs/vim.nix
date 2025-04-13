{ pkgs, inputs, system, ... }:

{
  programs.nixvim.config = {
    colorschemes.gruvbox.enable = true;

    opts = {
      autoindent = true;
      smartindent = true;
      expandtab = true;

      tabstop = 2;
      shiftwidth = 2;

      backspace = "indent,eol,start";
      number = true;
      relativenumber = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<C-B>";
        options.silent = true;
        action = "<cmd>Neotree toggle<CR>";
      }
    ];

    plugins = {
      lightline.enable = true;
      treesitter.enable = true;
      nvim-autopairs.enable = true;
      telescope.enable = true;
      cmp.enable = true;
      web-devicons.enable = true;
      smear-cursor.enable = true;
      gitsigns.enable = true;

      neo-tree = {
        enable = true;
        popupBorderStyle = "NC"; # double, none, rounded, shadow, single, solid
        filesystem.hijackNetrwBehavior = "open_current";
      };

      indent-blankline = {
        enable = true;
        settings = {
          exclude = {
            filetypes = [
              ""
              "dashboard"
            ];
            buftypes = [
              "terminal"
              "dashboard"
              "quickfix"
            ];
          };
        };
      };

      dashboard = {
        enable = true;
        settings = {
          shortcut_type = "number";
          theme = "hyper";
          config = {
            header = [
              "                                            oo oo"
              "                                                 "
              "dP  .dP .d8888b. 88d888b. .d8888b. 88d888b. dP dP"
              "88  d8' 88'  `88 88'  `88 88'  `88 88'  `88 88 88"
              "88.d8'  88.  .88 88.  .88 88.  .88 88       88 88"
              "888P'   `88888P8 88Y888P' `88888P' dP       dP dP"
              "                 88                              "
              "                 dP                              "
              "                                                 "
            ];
            mru.limit = 20;

            shortcut = [
              {
                action = {
                  __raw = ''
                    function(path)
                      path = path or vim.fn.getcwd()
                      vim.ui.input({ prompt = "file name: "}, function (input)
                        if input and input ~= "" then
                          local full_path = path .. "/" .. input
                          vim.fn.mkdir(vim.fn.fnamemodify(full_path, ":h"), "p")
                          vim.cmd("edit " .. full_path)
                        end
                      end)
                    end
                  '';
                };
                desc = "new file";
                group = "Number";
                icon = "󰝒 ";
                key = "n";
              }
              {
                action = {
                  __raw = "function(path) vim.cmd('Telescope find_files') end";
                };
                desc = "search files";
                group = "Label";
                icon = "󰍉 ";
                key = "f";
              }
              {
                action = {
                  __raw = "function(path) vim.cmd(':Telescope find_files search_dirs=/etc/nixos') end";
                };
                desc = "nixos";
                group = "DiagnosticHint";
                icon = "󱄅 ";
                icon_hl = "@variable";
                key = "x";
              }
            ];

            footer = [ "NVIM v0.11.0" ];
          };
        };
      };

      lsp = {
        enable = true;
        servers = {
          nixd = {
            enable = true;
            settings =
            let
              flake = "(builtins.getFlake \"${inputs.self}\")";
            in {
              nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
              options = rec {
                nixos.expr = "${flake}.nixosConfigurations.laptop.options";
                home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions [ ]";
                nixvim.expr = "${flake}.packages.${system}.nvim.options";
              };
            };
          };
        };
      };
    };
  };
}
