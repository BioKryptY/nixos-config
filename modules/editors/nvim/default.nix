#
# Neovim
#
{
  pkgs,
  user,
  lib,
  ...
}: {
  xdg = {
    configFile."nvim/lua".source = ./lua;
  };
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        # Syntax
        vim-nix
        vim-markdown
        # Customization
        wombat256-vim # Color scheme for lightline
        srcery-vim # Color scheme for text

        #FTerm-nvim
        trouble-nvim
        lsp_signature-nvim

        indent-blankline-nvim
        neo-tree-nvim # File-browser
        vimwiki # Wiki

        {
          plugin = fzf-lua;
          config = "lua require('plugin-configs._fzf-lua')";
        }
        {
          plugin = comment-nvim;
          config = "lua require('Comment').setup()";
        }
        {
          plugin = nvim-autopairs;
          config = "lua require('plugin-configs._autopairs')";
        }
        {
          plugin = nvim-surround;
          config = "lua require('nvim-surround').setup()";
        }
        {
          plugin = hop-nvim;
          config = "lua require('hop').setup()";
        }
        {
          plugin = which-key-nvim;
          config = "lua require('which-key').setup()";
        }
        {
          plugin = nvim-colorizer-lua;
          config = "lua require('colorizer').setup()";
        }
        luasnip
        {
          plugin = lualine-nvim;
          type = "lua";
          config = ''
            local function metals_status()
              return vim.g["metals_status"] or ""
            end
            require('lualine').setup(
              {
                options = { theme = 'wombat' },
                sections = {
                  lualine_a = {'mode' },
                  lualine_b = {'branch', 'diff' },
                  lualine_c = {'filename', metals_status },
                  lualine_x = {'encoding', 'filetype'},
                  lualine_y = {'progress'},
                  lualine_z = {'location'}
                }
              }
            )
          '';
        } # Status Line
        {
          plugin = nvim-treesitter.withAllGrammars; # Syntax Highlighting
          type = "lua";
          config = ''
            require('nvim-treesitter.configs').setup {
              highlight = { enable = true}
            }
          '';
        }
        {
          plugin = null-ls-nvim;
          type = "lua";
          config = ''
            local null_ls = require("null-ls")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            null_ls.setup({
                debug = true,
                sources = {
                    null_ls.builtins.formatting.alejandra.with({
                        command = "${pkgs.alejandra}/bin/alejandra"
                    }),
                    null_ls.builtins.formatting.lua_format.with({
                        command = "${pkgs.luaformatter}/bin/lua-format"
                    }),
                    null_ls.builtins.formatting.lua_format.with({
                        command = "${pkgs.beautysh}/bin/beautysh"
                    }),
                    null_ls.builtins.formatting.clang_format.with({
                        command = "${pkgs.clang-tools}/bin/clang-format"
                    })
                },

                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({
                                    bufnr = bufnr,
                                    filter = function(client)
                                        return client.name == "null-ls"
                                    end
                                })
                            end
                        })
                    end
                end
            })
          '';
        }
        #code-runner-nvim
        #{
        #  plugin = bufferline-nvim;
        # type = "lua";
        # config = ''
        # require("bufferline").setup{}
        # '';
        # }
        {
          plugin = nvim-web-devicons;
          type = "lua";
          config = ''
            require("nvim-web-devicons").setup{}
          '';
        }
        {
          plugin = telescope-nvim;
          type = "lua";
          config = ''
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
            require("telescope").setup{}
          '';
        }
        plenary-nvim
        markdown-preview-nvim # Markdown Preview
        {
          plugin = dracula-nvim;
          type = "lua";
          config = ''
            require("dracula").setup{}
            vim.cmd[[colorscheme dracula]]
          '';
        }
        {
          plugin = nvim-metals;
          type = "lua";
          config = ''
            metals_config = require("metals").bare_config()
            metals_config.settings = {
              useGlobalExecutable = true,
              showInferredType = true
            }
            metals_config.init_options.statusBarProvider = "on"
            local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
              pattern = { "scala", "sbt", },
              callback = function()
                require("metals").initialize_or_attach(metals_config)
              end,
              group = nvim_metals_group,
            })
          '';
        }
        cmp-path
        cmp-nvim-lsp
        cmp-buffer
        cmp-cmdline
        {
          plugin = nvim-cmp;
          type = "lua";
          config = ''
            local cmp = require'cmp'
            cmp.setup({
              snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                  require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                  -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                  -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
              },
              window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
              },
              mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
              }),
              sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'vsnip' }, -- For vsnip users.
                -- { name = 'luasnip' }, -- For luasnip users.
                -- { name = 'ultisnips' }, -- For ultisnips users.
                -- { name = 'snippy' }, -- For snippy users.
              }, {
                { name = 'buffer' },
              })
            })

            -- Set configuration for specific filetype.
            cmp.setup.filetype('gitcommit', {
              sources = cmp.config.sources({
                { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
              }, {
                { name = 'buffer' },
              })
            })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ '/', '?' }, {
              mapping = cmp.mapping.preset.cmdline(),
              sources = {
                { name = 'buffer' }
              }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
              mapping = cmp.mapping.preset.cmdline(),
              sources = cmp.config.sources({
                { name = 'path' }
              }, {
                { name = 'cmdline' }
              })
            })

            -- Set up lspconfig.
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
          '';
        }
        {
          plugin = ChatGPT-nvim;
          type = "lua";
          config = ''
            vim.keymap.set('n', '<leader>/', "<cmd>:ChatGPT<cr>" )
            require('chatgpt').setup {}
          '';
        }
        {
          plugin = lazygit-nvim;
          type = "lua";
          config = ''
            vim.keymap.set('n', '<leader>g', "<cmd>:LazyGit<cr>")
          '';
        }
        {
          plugin = toggleterm-nvim;
          type = "lua";
          config = ''
            vim.api.nvim_set_keymap('t', '<esc>', '<C-\\><C-n>', {noremap = true, silent = true})
              vim.keymap.set('n', '<leader>tt', "<cmd>:ToggleTerm <cr>" )
              require('toggleterm').setup {}
          '';
        }
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''
              require'lspconfig'.clangd.setup({
                cmd = { "${pkgs.clang-tools}/bin/clangd" }
              })
            vim.o.updatetime = 250
          '';
        }
      ];

      extraConfig = ''
        lua require('keymaps')

        set clipboard+=unnamedplus
        colorscheme srcery
        set expandtab
        set number                                " Set numbers

        let g:lualine = {
          \ 'colorscheme': 'wombat',
          \ }                                     " Color scheme lightline

        set cursorlineopt=number
        if has("autocmd")
          au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
        endif

        au FileType nix setlocal tabstop=2 shiftwidth=2
        au FileType cpp setlocal tabstop=2 shiftwidth=2
        au FileType c setlocal tabstop=2 shiftwidth=2

        highlight Comment cterm=italic gui=italic " Comments become italic
        hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal theme

        au CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})
        au BufRead,BufNewFile *.wiki setlocal textwidth=80 spell tabstop=2 shiftwidth=2
        au FileType xml setlocal tabstop=2 shiftwidth=2
        au FileType help wincmd L
        au FileType gitcommit setlocal spell

        nmap <F6> :NeoTreeShowToggle<CR>             " F6 open NeoTreeShowToggle
        au FileType cpp nmap <leader>r :w<CR>:TermExec cmd="g++ -o %:r % -std=c++17 && ./%:r"<cr><C-j>i
        au FileType c nmap <leader>r :w<CR>:TermExec cmd="gcc -o %:r % -std=c17 && ./%:r"<cr><C-j>i

      '';
    };
  };
}
