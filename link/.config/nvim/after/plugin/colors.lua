-- terminal colors
vim.opt.termguicolors = true

-- gruvbox settings
-- vim.g.gruvbox_italic = 1
-- vim.g.gruvbox_bold = 1
-- vim.g.gruvbox_underline = 1
-- vim.g.gruvbox_undercurl = 1
-- vim.g.gruvbox_inverse = 1
-- vim.g.gruvbox_contrast_dark = ""
-- vim.g.gruvbox_improved_warnings = 1
-- vim.g.gruvbox_improved_strings = 0

-- gruvbox-material
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_foreground = "original"
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_enable_italic = 0
vim.g.gruvbox_material_ui_contrast = "low"
vim.g.gruvbox_material_current_word = "underline"
-- vim.g.gruvbox_material_diagnostic_text_highlight = 1
vim.g.gruvbox_material_diagnostic_virtual_text = "colored"

function ColorMyPencils(color)
    color = color or "gruvbox-material"

    -- Background Colors
    vim.opt.background = "dark"
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    -- Cursor
    vim.api.nvim_set_hl(0, "Cursor", { reverse = true })
    -- CursorLine
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#232323" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#232323", fg = "orange", bold = true })
    -- augroup for CursorLine
    local CursorLineGroup = vim.api.nvim_create_augroup(
        "CursorLine", { clear = true }
    )
    vim.api.nvim_create_autocmd(
        { "VimEnter", "WinEnter", "BufWinEnter" },
        { pattern = "*", command = "set cursorline", group = CursorLineGroup }
    )
    vim.api.nvim_create_autocmd(
        { "WinLeave" },
        { pattern = "*", command = "set nocursorline", group = CursorLineGroup }
    )

    vim.cmd.colorscheme(color)
end

ColorMyPencils()
