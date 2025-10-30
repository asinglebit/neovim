local vscode = {}

local config = require('themes.config')
local theme = require('themes.theme')
local utils = require('themes.utils')

vscode.setup = config.setup

vscode.load = function(style)
    vim.cmd('hi clear')

    if vim.fn.exists('syntax_on') then
        vim.cmd('syntax reset')
    end

    vim.o.termguicolors = true
    vim.g.colors_name = 'vscode'

    if config.opts.terminal_colors then
        utils.terminal(require('themes.colors'))
    end

    local background = style or config.opts.style
    if background then
        vim.o.background = background
    end

    theme.set_highlights(config.opts)
    theme.link_highlight()

    if config.opts.group_overrides then
        for group, val in pairs(config.opts['group_overrides']) do
            vim.api.nvim_set_hl(0, group, val)
        end
    end
end

return vscode
