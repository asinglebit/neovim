return {
	-- Terminal presentation CLI for Markdown files.
	{
		"maaslalani/slides",
		build = "go install .",
		cmd = "Slides",
		keys = {
			{ "<leader>sl", "<cmd>Slides<CR>", desc = "Slides: Present current file" },
		},
		lazy = true,
		config = function()
			local function notify(message, level)
				vim.notify(message, level or vim.log.levels.INFO, { title = "slides" })
			end

			local function go_bin_candidate()
				if vim.env.GOBIN and vim.env.GOBIN ~= "" then
					return vim.env.GOBIN .. "/slides"
				end

				if vim.env.GOPATH and vim.env.GOPATH ~= "" then
					local first_path = vim.split(vim.env.GOPATH, ":", { plain = true })[1]
					if first_path and first_path ~= "" then
						return first_path .. "/bin/slides"
					end
				end

				return vim.fn.expand("~/go/bin/slides")
			end

			local function slides_executable()
				local from_path = vim.fn.exepath("slides")
				if from_path ~= "" then
					return from_path
				end

				local from_go = go_bin_candidate()
				if vim.fn.executable(from_go) == 1 then
					return from_go
				end
			end

			local function resolve_file(arg)
				local file = arg and arg ~= "" and vim.fn.expand(arg) or vim.api.nvim_buf_get_name(0)

				if file == "" then
					return nil, "No file selected for slides."
				end

				file = vim.fn.fnamemodify(file, ":p")
				if vim.fn.filereadable(file) == 0 then
					return nil, "File is not readable: " .. file
				end

				return file
			end

			vim.api.nvim_create_user_command("Slides", function(opts)
				local binary = slides_executable()
				if not binary then
					notify(
						"slides executable not found. Run :Lazy sync or install with: go install github.com/maaslalani/slides@latest",
						vim.log.levels.WARN
					)
					return
				end

				local file, err = resolve_file(opts.args)
				if not file then
					notify(err, vim.log.levels.ERROR)
					return
				end

				if opts.args == "" and vim.bo.modified then
					notify("Current buffer has unsaved changes; save it for slides to pick them up.", vim.log.levels.WARN)
				end

				vim.cmd("tabnew")
				vim.wo.number = false
				vim.wo.relativenumber = false
				vim.bo.buflisted = false

				local job_id = vim.fn.termopen({ binary, file }, {
					cwd = vim.fn.fnamemodify(file, ":h"),
				})

				if job_id <= 0 then
					notify("Failed to start slides.", vim.log.levels.ERROR)
					return
				end

				vim.cmd("startinsert")
			end, {
				nargs = "?",
				complete = "file",
				desc = "Present a Markdown file with maaslalani/slides",
			})
		end,
	},
}
