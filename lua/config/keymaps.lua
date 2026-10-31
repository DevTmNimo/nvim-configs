vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>b", "<C-w>w")

local api = require("Comment.api")
local esc = vim.api.nvim_replace_termcodes(
    "<Esc>", true, false, true
)

local function toggle_comment()
    local mode = vim.fn.visualmode()

    vim.api.nvim_feedkeys(esc, "nx", false)
    api.locked("toggle.linewise")(mode)

    vim.schedule(function()
        vim.cmd("nohlsearch")
        vim.cmd("redraw!")
    end)
end

vim.keymap.set("x", "L", toggle_comment, { desc = "toggle comments" })
vim.keymap.set("x", "F", toggle_comment, { desc = "toggle uncomments" })

-- ── Visual-mode line motions ─────────────────────────────────────────
keymap.set("v", "<leader>l",  "$")
keymap.set("v", "<leader>h",  "0")
keymap.set("v", "<leader>G",  "G",  { desc = "all the way down" })
keymap.set("v", "<leader>gg", "gg", { desc = "all the way up" })

-- ── File / buffer commands ───────────────────────────────────────────
keymap.set("n", "<leader>w", "<cmd>write<CR>",  { desc = "save",                silent = true })
keymap.set("n", "<leader>q", "<cmd>quit<CR>",   { desc = "quit",                silent = true })
keymap.set("n", "<leader>Q", "<cmd>quit!<CR>",  { desc = "quit without saving", silent = true })
keymap.set("n", "<leader>x", "<cmd>wq<CR>",     { desc = "save and quit",       silent = true })
keymap.set("n", "<Esc>",     "<cmd>nohlsearch<CR><Esc>", { desc = "clear search highlight", silent = true })

keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "find files", silent = true })
keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",  { desc = "live grep",  silent = true })

keymap.set("i", "jj", "<Esc>", { desc = "escape insert mode" })

-- diagnostics — works without LSP too (linters, etc.), so stays global
keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "line diagnostics" })

-- ── Remapped motions (intentional design choices) ────────────────────
keymap.set("n", "e", "w")
keymap.set("n", "q", "b")
keymap.set("v", "e", "w")
keymap.set("v", "q", "b")
keymap.set("n", "r", "e")

keymap.set("n", "<leader>n", "<cmd>Neotree toggle<CR>", { desc = "toggle file tree", silent = true })

keymap.set("n", "<Tab>",   "<cmd>bnext<CR>",     { desc = "next buffer",     silent = true })
keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "previous buffer", silent = true })

-- ── Line-navigation helpers (non-prefix, count-friendly) ─────────────
keymap.set("n", "<leader>l", "$")
keymap.set("n", "<leader>h", "0")

keymap.set("n", "<leader>J", function()
    vim.cmd("normal! " .. vim.v.count1 .. "gg")
end, { desc = "jump to line (count)" })

keymap.set("n", "<leader>d", "<C-d>", { desc = "scroll down" })
keymap.set("n", "<leader>u", "<C-u>", { desc = "scroll up" })

keymap.set("n", "<leader>G",  "G",  { desc = "all the way down" })
keymap.set("n", "<leader>gg", "gg", { desc = "all the way up" })

keymap.set("n", "<leader>ci", "cib", { remap = true, desc = "change inside block" })

-- ── Buffer-local LSP mappings: active only when an LSP attaches ──────
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buf = args.buf

        keymap.set("n", "gd", vim.lsp.buf.definition, {
            buffer = buf, silent = true, desc = "go to definition",
        })
        keymap.set("n", "<leader>k", vim.lsp.buf.hover, {
            buffer = buf, silent = true, desc = "hover",
        })
        keymap.set("n", "<leader>F", function()
            vim.lsp.buf.format({ bufnr = buf })
        end, { buffer = buf, silent = true, desc = "format buffer" })
    end,
})
