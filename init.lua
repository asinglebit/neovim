-- Load lazy config
require("config.lazy")

-- ==============================
-- Basic settings
-- ==============================
vim.cmd("syntax on")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.fillchars:append({ eob = " " })
vim.o.cursorline = true

-- ==============================
-- Telescope shortcuts
-- ==============================
vim.keymap.set("n", "<leader>fp", "<cmd>Telescope project<cr>", { desc = "Projects" })

-- ==============================
-- Buffer navigation
-- ==============================
vim.keymap.set("n", "H", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- ==============================
-- Window navigation
-- ==============================
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- ==============================
-- System clipboard
-- ==============================
local opts = { noremap = true, silent = true }

-- Copy
vim.keymap.set("v", "<leader>y", '"+y', opts)
vim.keymap.set("n", "<leader>y", '"+y', opts)
vim.keymap.set("n", "<leader>Y", '"+yg_', opts)
vim.keymap.set("n", "<leader>yy", '"+yy', opts)

-- Paste
vim.keymap.set("n", "<leader>p", '"+p', opts)
vim.keymap.set("n", "<leader>P", '"+P', opts)
vim.keymap.set("v", "<leader>p", '"+p', opts)
vim.keymap.set("v", "<leader>P", '"+P', opts)

-- ==============================
-- Diagnostics
-- ==============================
vim.keymap.set("n", "<leader>j", function()
    vim.diagnostic.open_float(nil, { focus = true, border = "rounded" })
end, { silent = true })

-- ==============================
-- Which-Key / nvim-silicon
-- ==============================
local wk = require("which-key")
wk.add({
    mode = { "v" },  -- Only active in visual mode
    { "<leader>s", group = "Silicon" },  -- Group heading in Which-Key
    { "<leader>sc", function() require("nvim-silicon").clip() end, desc = "Copy code screenshot to clipboard" },
    { "<leader>sf", function() require("nvim-silicon").file() end, desc = "Save code screenshot as file" },
    { "<leader>ss", function() require("nvim-silicon").shoot() end, desc = "Create code screenshot" },
})

