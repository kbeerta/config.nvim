return {
    {
        "catppuccin/nvim",
        enabled = false,
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
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        opts = {
            variant = "moon",
            extend_background_behind_borders = true,
            styles = {
                bold = true,
                italic = false,
                transparency = true,
            },
        },
        init = function()
            vim.cmd.colorscheme("rose-pine")
        end
    },
}
