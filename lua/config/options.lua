-- Cursor configuration
vim.opt.guicursor = {
    "n-v-c:block-Cursor",
    "i-ci:ver25",
    "r-cr:hor20",
}

-- Cursor highlight
vim.api.nvim_set_hl(0, "Cursor", {
    fg = "#000000",
    bg = "#ffffff",
})

vim.api.nvim_set_hl(0, "lCursor", {
    fg = "#000000",
    bg = "#ffffff",
})
