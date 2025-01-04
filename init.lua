vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

vim.opt.undofile = true
vim.opt.swapfile = false

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.scrolloff = 6

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<S-h>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>")

vim.keymap.set("n", "-", "<cmd>Oil<CR>")

vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua grep<CR>")
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>")

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
              formatEnabled = true,
              preview = false,
            },
          },
        },
        lua_ls = {},
        rust_analyzer = {},
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("KickstartLspAttach", { clear = true }),
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
