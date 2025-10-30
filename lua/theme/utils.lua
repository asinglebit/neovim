local utils = {}

utils.terminal = function(colors)
  vim.g.terminal_color_0 = colors.grey_900
  vim.g.terminal_color_1 = colors.red
  vim.g.terminal_color_2 = colors.green
  vim.g.terminal_color_3 = colors.yellow
  vim.g.terminal_color_4 = colors.blue
  vim.g.terminal_color_5 = colors.purple
  vim.g.terminal_color_6 = colors.teal
  vim.g.terminal_color_7 = colors.grey_200
  vim.g.terminal_color_8 = colors.grey_500
  vim.g.terminal_color_9 = colors.red
  vim.g.terminal_color_10 = colors.green
  vim.g.terminal_color_11 = colors.yellow
  vim.g.terminal_color_12 = colors.blue
  vim.g.terminal_color_13 = colors.purple
  vim.g.terminal_color_14 = colors.teal
  vim.g.terminal_color_15 = colors.grey_200
end

return utils
