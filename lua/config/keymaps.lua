-- ==============================
-- Telescope
-- ==============================
vim.keymap.set("n", "<leader>fp", "<cmd>Telescope project<cr>", {
  desc = "Projects",
})

-- ==============================
-- Buffer navigation
-- ==============================
vim.keymap.set("n", "H", "<cmd>bprevious<CR>", {
  desc = "Previous buffer",
})

vim.keymap.set("n", "L", "<cmd>bnext<CR>", {
  desc = "Next buffer",
})

-- ==============================
-- Window navigation
-- ==============================
vim.keymap.set("n", "<C-h>", "<C-w>h", {
  desc = "Move to left window",
})

vim.keymap.set("n", "<C-j>", "<C-w>j", {
  desc = "Move to below window",
})

vim.keymap.set("n", "<C-k>", "<C-w>k", {
  desc = "Move to above window",
})

vim.keymap.set("n", "<C-l>", "<C-w>l", {
  desc = "Move to right window",
})

-- ==============================
-- System clipboard
-- ==============================
local opts = { noremap = true, silent = true }

-- Copy
vim.keymap.set("v", "<leader>y", '"+y', vim.tbl_extend("force", opts, {
  desc = "Copy selection to clipboard",
}))

vim.keymap.set("n", "<leader>y", '"+y', vim.tbl_extend("force", opts, {
  desc = "Copy to clipboard",
}))

vim.keymap.set("n", "<leader>Y", '"+yg_', vim.tbl_extend("force", opts, {
  desc = "Copy to end of line",
}))

vim.keymap.set("n", "<leader>yy", '"+yy', vim.tbl_extend("force", opts, {
  desc = "Copy line to clipboard",
}))

-- Paste
vim.keymap.set("n", "<leader>p", '"+p', vim.tbl_extend("force", opts, {
  desc = "Paste after from clipboard",
}))

vim.keymap.set("n", "<leader>P", '"+P', vim.tbl_extend("force", opts, {
  desc = "Paste before from clipboard",
}))

vim.keymap.set("v", "<leader>p", '"+p', vim.tbl_extend("force", opts, {
  desc = "Paste over selection from clipboard",
}))

vim.keymap.set("v", "<leader>P", '"+P', vim.tbl_extend("force", opts, {
  desc = "Paste before from clipboard",
}))

-- ==============================
-- Diagnostics
-- ==============================
vim.keymap.set("n", "<leader>j", function()
  vim.diagnostic.open_float(nil, { focus = true, border = "rounded" })
end, {
  desc = "Show diagnostic under cursor",
  silent = true,
})

-- ==============================
-- Silicon (code screenshots)
-- ==============================
vim.keymap.set("v", "<leader>sc", function()
  require("nvim-silicon").clip()
end, {
  desc = "Silicon: Copy screenshot to clipboard",
})

vim.keymap.set("v", "<leader>sf", function()
  require("nvim-silicon").file()
end, {
  desc = "Silicon: Save screenshot to file",
})

vim.keymap.set("v", "<leader>ss", function()
  require("nvim-silicon").shoot()
end, {
  desc = "Silicon: Create screenshot",
})

