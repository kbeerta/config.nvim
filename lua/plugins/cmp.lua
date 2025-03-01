return {
    {
        "saghen/blink.cmp",
        version = "v0.*",
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                version = 'v2.*',
            }
        },
        opts = {
            keymap = { preset = "default" },
            snippets = { preset = "luasnip" },
            appearance = {
                nerd_font_variant = "mono",
                use_nvim_cmp_as_default = true,
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
        },
        opts_extend = { "sources.default" },
        config = function (_, opts) 
            vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { link = "Comment" })
            require("blink.cmp").setup(opts)
        end
    },
}
