local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local sorters = require('telescope.previewers')


-- setup
require('telescope').setup({
    defaults = {
        -- Mappings
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
            theme = "ivy",
            hidden = true,
            smartcase = true,
            layout_config = {
                cursor = { width = 0.9, height = 0.7 }
            }
        },
        git_files = {
            -- theme = "ivy",
            smartcase = true,
            layout_config = {
                cursor = { width = 1, height = 0.7 }
            }
        },
        live_grep = {
            theme = "ivy",
            smartcase = true,
            layout_config = {
                cursor = { width = 0.9, height = 0.7 }
            }
        }
    },
    extensions = {
        media = {
            backend = "viu", -- "none"|"ueberzug"|"viu"|"chafa"|"jp2a"|"catimg"
            move = true, -- experimental GIF preview
            cache_path = "/tmp/tele.media.cache",
        }
    }
})


-- remaps
vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files()
end)
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.live_grep()
end)

