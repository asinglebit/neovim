return {
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-project.nvim", -- projects extension
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
			local project_actions = require("telescope._extensions.project.actions")

            telescope.setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git/" },
                    color_devicons = false,
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.send_to_qflist,
                        },
                        n = {
                            ["q"] = actions.close,
                        },
                    },
                },
                pickers = {
                    find_files = { hidden = true },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    project = {
						base_dirs = {
							{path = '~/projects', max_depth = 2},
						},
						ignore_missing_dirs = true, -- default: false
						hidden_files = true, -- default: false
						theme = "dropdown",
						order_by = "asc",
						search_by = "title",
						sync_with_nvim_tree = true, -- default false
						-- default for on_project_selected = find project files
						on_project_selected = function(prompt_bufnr)
							-- Do anything you want in here. For example:
							project_actions.change_working_directory(prompt_bufnr, false)
							require("harpoon.ui").nav_file(1)
						end,
						mappings = {
							n = {
							['<leader>fd'] = project_actions.delete_project,
							-- ['r'] = project_actions.rename_project,
							["<leader>fa"] = project_actions.add_project,
							-- ['C'] = project_actions.add_project_cwd,
							-- ['f'] = project_actions.find_project_files,
							-- ['b'] = project_actions.browse_project_files,
							-- ['s'] = project_actions.search_in_project_files,
							-- ['R'] = project_actions.recent_project_files,
							-- ['w'] = project_actions.change_working_directory,
							-- ['o'] = project_actions.next_cd_scope,
							},
							-- i = {
							-- ['<c-d>'] = project_actions.delete_project,
							-- ['<c-v>'] = project_actions.rename_project,
							-- ['<c-a>'] = project_actions.add_project,
							-- ['<c-A>'] = project_actions.add_project_cwd,
							-- ['<c-f>'] = project_actions.find_project_files,
							-- ['<c-b>'] = project_actions.browse_project_files,
							-- ['<c-s>'] = project_actions.search_in_project_files,
							-- ['<c-r>'] = project_actions.recent_project_files,
							-- ['<c-l>'] = project_actions.change_working_directory,
							-- ['<c-o>'] = project_actions.next_cd_scope,
							-- }
						}
					}
                },
            })

            -- Load extensions
            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "project") -- <- correct name

            -- Keymaps
            vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
            vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
            vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
            vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })

            -- Projects keymap uses Lua functions, not strings
            vim.keymap.set("n", "<leader>fp", function() project_actions.projects() end, { desc = "List Projects" })

            -- vim.keymap.set("n", "<leader>fa", function()
            --     project_actions.add_project(vim.fn.getcwd())
            -- end, { desc = "Add Current Project" })

            -- vim.keymap.set("n", "<leader>fd", function()
            --     project_actions.delete_project()
            -- end, { desc = "Remove Project" })
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
    },
}