vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

vim.opt.showmode = false

vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.breakindent = true

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.cursorline = true
vim.opt.inccommand = "split"

vim.opt.scrolloff = 10

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

vim.keymap.set("n", "<S-h>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>")

vim.keymap.set("n", "-", "<cmd>Oil<CR>")

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
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
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local servers = {
                "ccls",
                "rust_analyzer",
            }

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("KickstartLspAttach", { clear = true }),
                callback = function(event)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf })
                    vim.keymap.set("n", "grn", vim.lsp.buf.rename, { buffer = event.buf })
                    vim.keymap.set("n", "gd", vim.lsp.buf.declaration, { buffer = event.buf })

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    local detach_augroup = vim.api.nvim_create_augroup("LspDetach", { clear = true })

                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
                        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = event.buf })
                    end

                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup = vim.api.nvim_create_augroup("KickstartLspHighlight", { clear = false })

                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = function()
                                vim.lsp.buf.document_highlight()
                            end
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = function()
                                vim.lsp.buf.clear_references()
                            end
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = detach_augroup,
                            callback = function(e)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = e.buf })
                            end,
                        })
                    end
                end
            })

            for _, server in ipairs(servers) do
                require("lspconfig")[server].setup({
                    capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities()), 
                })
            end
        end},
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-nvim-lsp",

                "saadparwaiz1/cmp_luasnip",
                {
                    "L3MON4D3/LuaSnip",
                    dependencies = {},
                },
            },
            config = function()

                local cmp = require("cmp")
                local luasnip = require("luasnip")

                luasnip.config.setup({})

                cmp.setup {
                    snippet = {
                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end,
                    },
                    completion = { completeopt = "menu,menuone,noinsert" },
                    mapping = cmp.mapping.preset.insert {
                        ["<C-n>"] = cmp.mapping.select_next_item(),
                        ["<C-p>"] = cmp.mapping.select_prev_item(),

                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    },
                    sources = {
                        { name = "path" },
                        { name = "luasnip" },
                        { name = "nvim_lsp" },
                    },
                }
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            main = "nvim-treesitter.configs",
            opts = {
                ensure_installed = { "lua" },
                auto_install = true,
                highlight = {
                    enable = true,
                },
                indent = { enable = true },
            },
        }
    })
