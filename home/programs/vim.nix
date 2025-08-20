{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];
  
  options = {
    vim = {
      enable = lib.mkEnableOption "enable nixvim module";
      nixHost = lib.mkOption {
        type = with lib.types; uniq str;
        example = "laptop";
        description = "the nixos configuration host to use for nixd";
      };
      pythonPackage = lib.mkOption {
        type = lib.types.package;
        example = "pkgs.python3";
        default = pkgs.python3;
        description = "the python package to use";
      };
    };
  };

  config = lib.mkIf config.vim.enable {
    programs.nixvim = {
      config = {
        enable = true;
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
            key = "<C-B>";
            options.silent = true;
            action = "<cmd>Neotree toggle<CR>";
          }
          {
            key = "<A-Tab>";
            options.noremap = true;
            options.silent = true;
            action = "<cmd>tabnext<CR>";
          }
          {
            key = "<A-S-Tab>";
            options.noremap = true;
            options.silent = true;
            action = "<cmd>tabprevious<CR>";
          }
          {
            key = "<C-H>";
            action = "<cmd>wincmd h<CR>";
          }
          {
            key = "<C-L>";
            action = "<cmd>wincmd l<CR>";
          }
          {
            key = "<C-J>";
            action = "<cmd>wincmd j<CR>";
          }
          {
            key = "<C-K>";
            action = "<cmd>wincmd k<CR>";
          }
          {
            key = "<esc>";
            action = "<C-\\><C-n>";
          }
        ];

        plugins = {
          lightline.enable = true;
          treesitter.enable = true;
          nvim-autopairs.enable = true;
          telescope.enable = true;
          web-devicons.enable = true;
          smear-cursor.enable = true;
          gitsigns.enable = true;

          toggleterm = {
            enable = true;
            settings.open_mapping = "[[<C-`>]]";
          };

          lspkind = {
            enable = true;
            cmp.enable = true;
          };

          cmp = {
            enable = true;
            autoEnableSources = true;
            settings.mapping.__raw = /* lua */ ''
              cmp.mapping.preset.insert({
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-CR>"] = cmp.mapping.confirm({ select = true }),
                ["<CR>"] = cmp.mapping.confirm(),
                ["C-Space>"] = cmp.mapping.complete(),
              })
            '';
            settings.sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
              { name = "luasnip"; }
              { name = "treesitter"; }
            ];
            settings.window.completion.border = [ "┌" "─" "┐" "│" "┘" "─" "└" "│" ];
          };

          neo-tree = {
            enable = true;
            popupBorderStyle = "NC"; # double, none, rounded, shadow, single, solid
            filesystem = {
              useLibuvFileWatcher = true;
              hijackNetrwBehavior = "open_current";
              findArgs = {
                fd = [
                  "--hidden"
                  "--exclude"
                  ".git"
                ];
              };
            };
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
                      __raw = ''
                        function(path)
                          path = path or vim.fn.getcwd()
                          vim.cmd("Neotree " .. path)
                        end
                      '';
                    };
                    desc = "open project";
                    group = "DiagnosticHint";
                    icon = "󰉋 ";
                    key = "p";
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
                      __raw = "function(path) vim.cmd(':Neotree /etc/nixos') end";
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
              pylsp.enable = true;
              pylsp.pythonPackage = config.vim.pythonPackage;
              zls.enable = true;
              nixd = {
                enable = true;
                settings =
                let
                  flake = ''(builtins.getFlake "/etc/nixos")'';
                  system = ''''${builtins.currentSystem}'';
                in {
                  nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
                  options = rec {
                    nixos.expr = "${flake}.nixosConfigurations.${config.vim.nixHost}.options";
                    home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions [ ]";
                    nixvim.expr = "${flake}.inputs.nixvim.nixvimConfigurations.${system}.default.options";
                  };
                };
              };
            };
          };
        };
      };
    };
    # programs.nixvim.enable = true;
  };
}
