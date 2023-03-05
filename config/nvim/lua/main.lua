require("plugins").setup()

vim.api.nvim_set_hl(0, "NormalFloat", {bg="#3B4252"})
vim.api.nvim_set_hl(0, "TelescopeNormal", {bg="#3B4252"})
vim.api.nvim_set_hl(0, "Pmenu", { fg="#FF0000", bg="blue" })

vim.cmd('colorscheme jellybeans-nvim')

