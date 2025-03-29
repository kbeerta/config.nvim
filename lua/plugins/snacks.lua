return {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
        picker = {},
        indent = {
            only_scope = true,
            animate = {
                enabled = false,
            },
        },
    },
    keys = {
        { "<leader>ff", function() Snacks.picker.files() end },
        { "<leader>fb", function() Snacks.picker.buffers() end },

        { "<leader>sg", function() Snacks.picker.grep() end },
    }
}
