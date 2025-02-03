local keymaps = require("core.keymaps")

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "ibhagwan/fzf-lua", "saghen/blink.cmp" },
        opts = {
            servers = {
                zls = {},
                ccls = {},
                nixd = {},
                phpactor = {},
                rust_analyzer = {}
            }
        },
        config = function(_, opts)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("LspAttachCallback", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    if not client then
                        return
                    end

                    if client:supports_method("textDocument/formatting") then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                            end
                        })
                    end

                    if client:supports_method("textDocument/hover") then
                        keymaps.map("n", "K", vim.lsp.buf.hover, { buffer = args.buf })
                    end
                    
                    if client:supports_method("textDocument/definition") then
                        keymaps.map("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
                    end

                    if client:supports_method("textDocument/rename") then
                        keymaps.map("n", "grn", vim.lsp.buf.rename, { buffer = args.buf })
                    end

                    if client:supports_method("textDocument/codeAction") then
                        keymaps.map("n", "gra", "<cmd>FzfLua lsp_code_actions", { buffer = args.buf })
                    end

                    if client:supports_method("textDocument/references") then
                        keymaps.map("n", "grr", "<cmd>FzfLua lsp_references<CR>", { buffer = args.buf })
                    end

                    if client:supports_method("textDocument/implementation") then
                        keymaps.map("n", "gri", "<cmd>FzfLua lsp_implementations<CR>", { buffer = args.buf })
                    end

                    if client:supports_method("textDocument/documentSymbol") then
                        keymaps.map("n", "gO", "<cmd>FzfLua lsp_document_symbols<CR>", { buffer = args.buf })
                    end

                    if client:supports_method("textDocument/highlight") then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.document_highlight()
                            end
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.clear_references()
                            end
                        })
                    end

                    vim.api.nvim_create_autocmd("LspDetach", {
                        buffer = args.buf,
                        callback = function()
                            vim.api.nvim_clear_autocmds({ buffer = args.buf })
                        end
                    })
                end
            })

            for server, config in pairs(opts.servers) do
                config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
                require("lspconfig")[server].setup(config)
            end
        end
    }
}
