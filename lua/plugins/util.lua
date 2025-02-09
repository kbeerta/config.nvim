return {
    {
        "stevearc/oil.nvim",
        lazy = false,
        keys = {
            { "-", "<cmd>Oil<CR>", noremap = true, silent = true },
        },
        opts = {
            columns = {},
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
            view_options = { show_hidden = true },
            lsp_file_methods = { enabled = true },
        }
    },
    {
        "ibhagwan/fzf-lua",
        keys = {
            { "<leader>ff", "<cmd>FzfLua files<CR>", noremap = true, silent = true },
            { "<leader>fb", "<cmd>FzfLua buffers<CR>", noremap = true, silent = true },
            { "<leader>fg", "<cmd>FzfLua live_grep<CR>", noremap = true, silent = true },
        },
        opts = {
            winopts = {
                split = "belowright new",
                preview = {
                    border = "none",
                    vertical = "up:60%",
                    scrollbar = false,
                },
            }
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    }
}
