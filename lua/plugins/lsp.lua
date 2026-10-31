return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        vim.lsp.config("gopls", {
            capabilities = capabilities,
            settings = {
                gopls = {
                    staticcheck = true,
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                    },
                },
            },
        })
        vim.lsp.enable("gopls")

        -- diagnostics display
        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = { source = true, border = "rounded" },
        })

        -- keymaps
        vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
        vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
        vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

        -- organize imports + format on save (Go)
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
                local params = vim.lsp.util.make_range_params(0, "utf-16")
                params.context = { only = { "source.organizeImports" } }
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
                for client_id, res in pairs(result or {}) do
                    for _, action in pairs(res.result or {}) do
                        if action.edit then
                            local client = vim.lsp.get_client_by_id(client_id)
                            vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                        end
                    end
                end
                vim.lsp.buf.format({ async = false })
            end,
        })

        vim.api.nvim_create_user_command("LspInfo", function()
            vim.print(vim.lsp.get_clients({ bufnr = 0 }))
        end, {})

        vim.api.nvim_create_user_command("LspStop", function(opts)
            local clients = vim.lsp.get_clients({ name = opts.args })
            for _, client in ipairs(clients) do
                client:stop()
            end
        end, { nargs = 1 })
    end,
}
