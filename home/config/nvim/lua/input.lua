-- Fix S-Insert
vim.api.nvim_set_keymap('!', '<S-Insert>', '<MiddleMouse>', {})

--Keep search results at the center of the screen
vim.api.nvim_set_keymap('n', 'n', 'nzz', {})
vim.api.nvim_set_keymap('n', 'N', 'Nzz', {})
vim.api.nvim_set_keymap('n', '*', '*zz', {})
vim.api.nvim_set_keymap('n', '#', '#zz', {})
vim.api.nvim_set_keymap('n', 'g*', 'g*zz', {})
vim.api.nvim_set_keymap('n', 'g#', 'g#zz', {})

--Navigation mappings
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true })

vim.api.nvim_set_keymap('n', '<Leader>e', ':bn<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>q', ':bp<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>bd', ':silent! bp<bar>sp<bar>silent! bn<bar>bd<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<Leader><space>', ':nohlsearch<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<space>', 'za', { noremap = true })
