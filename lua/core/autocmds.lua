vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.fn.clearjumps()
    end
})
