return {
  "Isrothy/neominimap.nvim",
  version = "v3.x.x",
  lazy = false,  -- don't lazy-load; load always
  keys = {
    { "<leader>mm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
    { "<leader>mo", "<cmd>Neominimap Enable<cr>", desc = "Enable global minimap" },
    { "<leader>mc", "<cmd>Neominimap Disable<cr>", desc = "Disable global minimap" },
    { "<leader>mr", "<cmd>Neominimap Refresh<cr>", desc = "Refresh global minimap" },
    { "<leader>mwt", "<cmd>Neominimap WinToggle<cr>", desc = "Toggle minimap for current window" },
    { "<leader>mwr", "<cmd>Neominimap WinRefresh<cr>", desc = "Refresh minimap for current window" },
    { "<leader>mwo", "<cmd>Neominimap WinEnable<cr>", desc = "Enable minimap for current window" },
    { "<leader>mwc", "<cmd>Neominimap WinDisable<cr>", desc = "Disable minimap for current window" },
    { "<leader>mtt", "<cmd>Neominimap TabToggle<cr>", desc = "Toggle minimap for current tab" },
    { "<leader>mtr", "<cmd>Neominimap TabRefresh<cr>", desc = "Refresh minimap for current tab" },
    { "<leader>mto", "<cmd>Neominimap TabEnable<cr>", desc = "Enable minimap for current tab" },
    { "<leader>mtc", "<cmd>Neominimap TabDisable<cr>", desc = "Disable minimap for current tab" },
    { "<leader>mbt", "<cmd>Neominimap BufToggle<cr>", desc = "Toggle minimap for current buffer" },
    { "<leader>mbr", "<cmd>Neominimap BufRefresh<cr>", desc = "Refresh minimap for current buffer" },
    { "<leader>mbo", "<cmd>Neominimap BufEnable<cr>", desc = "Enable minimap for current buffer" },
    { "<leader>mbc", "<cmd>Neominimap BufDisable<cr>", desc = "Disable minimap for current buffer" },
    { "<leader>mf", "<cmd>Neominimap Focus<cr>", desc = "Focus on minimap" },
    { "<leader>mu", "<cmd>Neominimap Unfocus<cr>", desc = "Unfocus minimap" },
    { "<leader>ms", "<cmd>Neominimap ToggleFocus<cr>", desc = "Toggle minimap focus" },
  },
  init = function()
    -- Some recommended settings when using float layout:
    vim.opt.wrap = false
    vim.opt.sidescrolloff = 36
    
    vim.g.neominimap = {
      auto_enable = true,
    }
  end,
}
