return {}
-- return {
--   "karb94/neoscroll.nvim",
--   lazy = false,
--   config = function()
--     local neoscroll = require("neoscroll")

--     neoscroll.setup({
--       easing_function = "cubic",
--       hide_cursor = true,
--       stop_eof = true,
--       respect_scrolloff = true,
--       performance_mode = true,
--     })

--     local scroll_opts = { cursor = true, duration = 100 }

--     -- half-page
--     vim.keymap.set('n', '<C-u>', function() neoscroll.scroll(-vim.wo.scroll, scroll_opts) end)
--     vim.keymap.set('n', '<C-d>', function() neoscroll.scroll(vim.wo.scroll, scroll_opts) end)

--     -- full-page
--     vim.keymap.set('n', '<C-b>', function() neoscroll.scroll(-vim.api.nvim_win_get_height(0), { cursor = true, duration = 450 }) end)
--     vim.keymap.set('n', '<C-f>', function() neoscroll.scroll(vim.api.nvim_win_get_height(0), { cursor = true, duration = 450 }) end)

--     -- page up/down
--     vim.keymap.set('n', '<PageUp>', function() neoscroll.scroll(-vim.api.nvim_win_get_height(0), { cursor = true, duration = 450 }) end)
--     vim.keymap.set('n', '<PageDown>', function() neoscroll.scroll(vim.api.nvim_win_get_height(0), { cursor = true, duration = 450 }) end)

--     -- jump to top / bottom
--     vim.keymap.set('n', 'gg', function() neoscroll.scroll(-vim.fn.line(".") + 1, { cursor = true, duration = 600 }) end)
--     vim.keymap.set('n', 'G',  function() neoscroll.scroll(vim.fn.line("$") - vim.fn.line("."), { cursor = true, duration = 600 }) end)

--     -- center cursor
--     vim.keymap.set('n', 'zz', function() neoscroll.scroll(0, { cursor = true, duration = 250, stop_eof = false }) end)
--     vim.keymap.set('n', 'zt', function() neoscroll.scroll(0, { cursor = true, duration = 250, stop_eof = false, position = "top" }) end)
--     vim.keymap.set('n', 'zb', function() neoscroll.scroll(0, { cursor = true, duration = 250, stop_eof = false, position = "bottom" }) end)
--   end,
-- }