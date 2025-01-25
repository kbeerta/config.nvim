
local map = function(mode, lhs, rhs, opts)
    local opts = vim.tbl_extend("force", opts or {}, { noremap = true, silent = true })
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

map("n", "-", "<cmd>Oil<CR>")

map("n", "<leader>ff", "<cmd>FzfLua files<CR>")
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>")
map("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>")

