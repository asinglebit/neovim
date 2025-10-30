local config = {}

local defaults = {
    transparent = false,
    italic_comments = false,
    italic_inlayhints = false,
    underline_links = false,
    color_overrides = {},
    group_overrides = {},
    disable_nvimtree_bg = true,
    terminal_colors = true,
}

config.opts = {}

config.setup = function()
    config.opts = vim.tbl_extend('force', defaults, {})
end

config.setup()

return config
