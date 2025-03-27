
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
        end
    end
})

local servers = {}
for _, v in ipairs(vim.api.nvim_get_runtime_file("lsp/*", true)) do
    local name =  vim.fn.fnamemodify(v, ":t:r")
    servers[name] = true
end

vim.lsp.enable(vim.tbl_keys(servers))
