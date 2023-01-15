-- terminal colors
vim.opt.termguicolors = true

-- gruvbox settings
-- vim.g.gruvbox_italic = 1
-- vim.g.gruvbox_bold = 1
-- vim.g.gruvbox_underline = 1
-- vim.g.gruvbox_undercurl = 1
-- vim.g.gruvbox_inverse = 1
-- vim.g.gruvbox_contrast_dark = "hard"
-- vim.g.gruvbox_improved_warnings = 1
-- vim.g.gruvbox_improved_strings = 0
require("gruvbox").setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = false,
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = false, -- invert background for search, diffs, statuslines and errors
    contrast = "", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = true,
})

function ColorMyPencils(color)
    color = color or "gruvbox"
    vim.cmd.colorscheme(color)
    vim.opt.background = "dark"
    -- Background Colors
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    -- Cursor
    vim.api.nvim_set_hl(0, "Cursor", { reverse = true })
    -- CursorLine
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#232323" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#232323", fg="orange", bold=true })
end

ColorMyPencils()

-- augroup for CursorLine
local CursorLineGroup = vim.api.nvim_create_augroup(
    "CursorLine", { clear = true }
)
vim.api.nvim_create_autocmd(
    { "VimEnter", "WinEnter", "BufWinEnter" },
    { pattern = "*", command = "set cursorline", group=CursorLineGroup }
)
vim.api.nvim_create_autocmd(
    { "WinLeave" },
    { pattern = "*", command = "set nocursorline", group=CursorLineGroup }
)
