return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha",
            no_italic = true,
            transparent_background = true
        },
        init = function()
            vim.cmd.colorscheme("catppuccin")
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    }
}
