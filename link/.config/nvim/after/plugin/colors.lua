-- terminal colors
vim.opt.termguicolors = true
-- dark background
vim.opt.background = "dark"

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
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_disable_italic_comment = 1
vim.g.gruvbox_material_ui_contrast = "low"
vim.g.gruvbox_material_current_word = "underline"
-- vim.g.gruvbox_material_diagnostic_text_highlight = 1
vim.g.gruvbox_material_diagnostic_virtual_text = "colored"

-- print(vim.api.nvim_get_hl_by_name("DiagnosticWarn", true).fg)

function ColorMyPencils(color)
    color = color or "gruvbox-material"
    vim.cmd.colorscheme(color)

    -- Background Colors
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    -- Diagnostic Icons
    vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticsError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticsWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticsInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticsHint" })

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
end

ColorMyPencils()
