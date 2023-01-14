vim.g.mapleader = " "

-- netrw
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- tabs
vim.keymap.set('n', '<leader>tj',  vim.cmd.tabfirst)
vim.keymap.set('n', '<leader>tl',  vim.cmd.tabnext)
vim.keymap.set('n', '<leader>th',  vim.cmd.tabprev)
vim.keymap.set('n', '<leader>tk',  vim.cmd.tablast)
vim.keymap.set('n', '<leader>tt',  vim.cmd.tabedit)
vim.keymap.set('n', '<leader>tn',  vim.cmd.tabnew)
vim.keymap.set('n', '<leader>tm',  vim.cmd.tabm)
vim.keymap.set('n', '<leader>tx',  vim.cmd.tabclose)

-- visual line move -- It will automatically indent with =
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Change behaviour of J to move bottom line to current line without
-- moving the cursor
vim.keymap.set('n', 'J', "mzJ`z")

-- This will paste but not override the register. In cases
-- like pasting over existing text, it does not take
-- existing text into the register
vim.keymap.set('x', '<leader>p', "\"_dP")
-- This will yank into the system clipboard, useful when
-- separating the vim and system clipboards
vim.keymap.set('n', '<leader>y', "\"+y")
vim.keymap.set('v', '<leader>y', "\"+y")
vim.keymap.set('n', '<leader>Y', "\"+Y")
-- Same as above but for cutting
vim.keymap.set('n', '<leader>d', "\"_d")
vim.keymap.set('v', '<leader>d', "\"_d")

-- Unbinding capital Q
vim.keymap.set('n', 'Q', "<nop>")
-- tmux-sessionizer
vim.keymap.set('n', '<leader>po', "<cmd>silent !tmux neww tms<CR>")
-- some LSP thing
vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format()
end)

-- Imba substitute command
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- set breakpoints
vim.keymap.set('n', '<leader>bp', vim.cmd.Break)
