return {
    {
        "navarasu/onedark.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            local onedark = require('onedark')
            onedark.setup {
                style = 'warmer'
            }
            onedark.load()

            -- apply your custom highlights directly after loading
            local theme = require('theme.highlights')
            theme.set_highlights()
            theme.link_highlight()
        end
    }
}
