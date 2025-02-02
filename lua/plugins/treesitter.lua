return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            indent = { enable = true },
            highlight = { enable = true },
        }
    },
}
