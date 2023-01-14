vim.g.tmux_navigator_no_mappings = 1
vim.g.tmux_navigator_disable_when_zoomed = 1

vim.keymap.set('n', "<C-H>", vim.cmd.TmuxNavigateLeft)
vim.keymap.set('n', "<C-J>", vim.cmd.TmuxNavigateDown)
vim.keymap.set('n', "<C-K>", vim.cmd.TmuxNavigateUp)
vim.keymap.set('n', "<C-L>", vim.cmd.TmuxNavigateRight)
