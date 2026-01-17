-- ==============================
-- Diagnostics signs
-- ==============================
local signs = {
  Error = " ",
  Warn  = " ",
  Info  = " ",
  Hint  = "󰌵 ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded" },
  linehl = false,
})

