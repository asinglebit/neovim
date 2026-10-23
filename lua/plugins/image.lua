return {
	{
		"folke/snacks.nvim",
		-- set up before any file is read, so `nvim photo.png` opens as a picture rather than bytes
		priority = 1000,
		lazy = false,
		opts = {
			-- inside tmux, snacks turns on allow-passthrough for its own pane, so tmux.conf needs nothing
			image = {
				enabled = true,
				-- vault notes embed attachments by bare name, so look where `<leader>oi` saves them
				resolve = function(file, src)
					local api = package.loaded.obsidian and require("obsidian.api")
					if not (api and api.find_workspace(file)) then
						return nil
					end
					local path = api.resolve_attachment_path(src)
					return vim.uv.fs_stat(path) and path or nil
				end,
			},
		},
	},
}
