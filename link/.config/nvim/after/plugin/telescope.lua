local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local themes = require("telescope.themes")

-- extensions
require("telescope").load_extension("media")
require("telescope").load_extension("lazygit")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("vimspector")

-- variables
local default_file_ignore_patterns = {
    ".git/*",
    "node_modules/*"
}


-- setup
require("telescope").setup({
    defaults = {
        -- rg
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--hidden",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        prompt_prefix = "   ",
        -- mappings
        mappings = {
            i = {
                ["<ESC>"] = actions.close,
                ["<C-j>"] = {
                    actions.move_selection_next, type = "action",
                    opts = { nowait = true, silent = true }
                },
                ["<C-k>"] = {
                    actions.move_selection_previous, type = "action",
                    opts = { nowait = true, silent = true }
                }
            }
        }
    },
    pickers = {
        find_files = {
            hidden = true,
            smartcase = true,
            file_ignore_patterns = default_file_ignore_patterns,
            layout_config = {
                cursor = { width = 1, height = 0.7 },
                prompt_position = "top"
            }
        },
        git_files = {
            smartcase = true,
            layout_config = {
                cursor = { width = 1, height = 0.7 },
                prompt_position = "top"
            }
        },
        grep_string = {
            hidden = true,
            smartcase = true,
            file_ignore_patterns = default_file_ignore_patterns,
            layout_config = {
                cursor = { width = 1, height = 0.7 },
                prompt_position = "top"
            }
        }
    },
    extensions = {
        media = {
            backend = "viu", -- "none"|"ueberzug"|"viu"|"chafa"|"jp2a"|"catimg"
            move = true, -- experimental GIF preview
            cache_path = "/tmp/tele.media.cache",
        },
        ["ui-select"] = {
            themes.get_dropdown({})
        }
    }
})

-- remaps
vim.keymap.set("n", "<leader>pf", function()
    builtin.find_files()
end)
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>vs", require("telescope").extensions.vimspector.configurations, {})
