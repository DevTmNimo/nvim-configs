vim.cmd("syntax on")
vim.cmd("filetype on")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

vim.opt.number = true
vim.opt.tabstop = 6
vim.opt.guicursor = "a:block-Cursor"

require("lazy").setup("plugins", {
    rocks = { enabled = false },
})
require("config.keymaps")

vim.diagnostic.config({
    virtual_text = true,
})

require("config.options")
