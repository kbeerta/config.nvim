require("core")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      no_italic = true,
      transparent_background = true,
    },
    init = function()
      vim.cmd.colorscheme("catppuccin")
    end
  },
  {
    "stevearc/oil.nvim",
    opts = {
      columns = {},
      view_options = {
        show_hidden = true,
      }
    },
  },
  {
    "ibhagwan/fzf-lua",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        }
      },
      {
        "saghen/blink.cmp",
        version = "v0.*",
        lazy = false,
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
        opts = {
          keymap = { preset = "default" },
          appearance = {
            nerd_font_variant = "mono",
            use_nvim_cmp_as_default = true
          },
          sources = {
            default = { "lsp", "path", "snippets", "buffer" },
          },
        },
        opts_extend = { "sources.default" }
      },
    },
    opts = {
      servers = {
        zls = {},
        ccls = {},
        nixd = {},
        pylsp = {
          plugins = {
            ruff = {
              enabled = true,
              preview = false,
              formatEnabled = true,
            },
            rope_autoimport = {
              enabled = true,
            }
          },
        },
        lua_ls = {},
        phpactor = {},
        rust_analyzer = {},
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttachCallback", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if not client then
            return
          end

          if client.supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end
            })
          end

          if client.supports_method(vim.lsp.protocol.Methods.textDocument_rename) then
            vim.keymap.set("n", "grn", vim.lsp.buf.rename, { buffer = args.buf })
          end

          if client.supports_method(vim.lsp.protocol.Methods.textDocument_declaration) then
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf })
          end

          if client.supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
          end

          if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.document_highlight()
              end
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.clear_references()
              end
            })
          end

          vim.api.nvim_create_autocmd("LspDetach", {
            buffer = args.buf,
            callback = function()
              vim.api.nvim_clear_autocmds({ buffer = args.buf })
            end
          })
        end
      })

      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        require("lspconfig")[server].setup(config)
      end
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      auto_install = true,
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      show_buffer_icons = false,
      show_buffer_close_icons = false,
    },
    config = function(_, opts)
      require("bufferline").setup({
        options = opts,
        highlights = require("catppuccin.groups.integrations.bufferline").get(),
      })
    end
  }
}, {
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json", -- Config folder is readonly because of home manager
})
