return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            local ts = require("nvim-treesitter")
            ts.setup()
            ts.install({ "go", "gomod", "gosum", "gowork", "lua" })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "go", "gomod", "gowork", "gosum" },
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
}
