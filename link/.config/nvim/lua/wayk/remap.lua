vim.g.mapleader = " "

-- netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- tabs
vim.keymap.set('n', '<leader>tj',  vim.cmd.tabfirst)
vim.keymap.set('n', '<leader>tl',  vim.cmd.tabnext)
vim.keymap.set('n', '<leader>th',  vim.cmd.tabprev)
vim.keymap.set('n', '<leader>tk',  vim.cmd.tablast)
vim.keymap.set('n', '<leader>tt',  vim.cmd.tabedit)
vim.keymap.set('n', '<leader>tn',  vim.cmd.tabnew)
vim.keymap.set('n', '<leader>tm',  vim.cmd.tabm)
vim.keymap.set('n', '<leader>tx',  vim.cmd.tabclose)
