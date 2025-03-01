return {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
        image = {},
        indent = {
            only_scope = true,
            animate = {
                enabled = false,
            },
        },
        picker = {},
    },
    keys = {
        { "<leader>fb", function() Snacks.picker.buffers() end },
        { "<leader>ff", function() Snacks.picker.files() end },

        { "<leader>sg", function() Snacks.picker.grep() end },

        { "gd", function() Snacks.picker.lsp_definitions() end },
        { "gD", function() Snacks.picker.lsp_declarations() end },
        { "gr", function() Snacks.picker.lsp_references() end, nowait = true },
        { "gI", function() Snacks.picker.lsp_implementations() end },
        { "gy", function() Snacks.picker.lsp_type_definitions() end },

        { "<leader>ss", function() Snacks.picker.lsp_symbols() end },
        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end },
    }
}
