require("persistence").setup()

vim.api.nvim_set_keymap("n", "<leader>pl", [[<cmd>lua require("persistence").load()<cr>]], {})
