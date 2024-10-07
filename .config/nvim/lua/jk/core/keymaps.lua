local map = vim.keymap.set

local opts = { noremap = true, silent = true }

map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- delete single character without copying into register
map('n', 'x', '"_x', opts)

-- Keep last yanked when pasting
map('v', 'p', '"_dP', opts)

-- Vertical scroll and center
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)

map('n', '<Leader>q', '<Cmd>confirm q<CR>', { desc = 'quit window' })
map('n', '<Leader>Q', '<Cmd>confirm qall<CR>', { desc = 'exit nvim' })

map('i', '<C-b>', '<ESC>^i', { desc = 'move beginning of line' })
map('i', '<C-e>', '<End>', { desc = 'move end of line' })
map('i', '<C-h>', '<Left>', { desc = 'move left' })
map('i', '<C-l>', '<Right>', { desc = 'move right' })
map('i', '<C-j>', '<Down>', { desc = 'move down' })
map('i', '<C-k>', '<Up>', { desc = 'move up' })

-- map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
-- map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
-- map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
-- map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map('n', '|', '<Cmd>vsplit<CR>', { desc = 'Vertical Split' })
map('n', '\\', '<Cmd>split<CR>', { desc = 'Horizontal Split' })

-- Resize window using <ctrl> arrow keys
-- map("n", "<Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
-- map("n", "<Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
-- map("n", "<Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
-- map("n", "<Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

map('n', '<Esc>', '<cmd>noh<CR>', { desc = 'General Clear highlights' })

-- nvimtree
map('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'nvimtree toggle window' })
map('n', '<leader>o', '<cmd>NvimTreeFocus<CR>', { desc = 'nvimtree focus window' })

-- buffer
-- stylua: ignore start
map('n', '<Leader>c', function() require('nvchad.tabufline').close_buffer() end, { desc = 'Close buffer' })
-- map('n', '<Leader>C', function() require('nvchad.tabufline').close(0, true) end, { desc = 'Force close buffer' })
map('n', '<S-l>', function() require('nvchad.tabufline').next() end, { desc = 'Next buffer' })
map('n', '<S-h>', function() require('nvchad.tabufline').prev() end, { desc = 'Previous buffer' })
map('n', ']b', function() require('nvchad.tabufline').next() end, { desc = 'Next buffer' })
map('n', '[b', function() require('nvchad.tabufline').prev() end, { desc = 'Previous buffer' })
map('n', '>b', function() require('nvchad.tabufline').move_buf(1) end, { desc = 'Move buffer tab right' })
map('n', '<b', function() require('nvchad.tabufline').move_buf(-1) end, { desc = 'Move buffer tab left' })

map('n', '<Leader>bc', function() require('nvchad.tabufline').closeAllBufs(false) end, { desc = 'Close all buffers except current' })
map('n', '<Leader>bC', function() require('nvchad.tabufline').closeAllBufs(true) end, { desc = 'Close all buffers' })
map('n', '<Leader>bl', function() require('nvchad.tabufline').closeBufs_at_direction('left') end, { desc = 'Close all buffers to the left' })
map('n', '<Leader>bn', function() require('nvchad.tabufline').next() end, { desc = 'Next buffer' })
map('n', '<Leader>bp', function() require('nvchad.tabufline').prev() end, { desc = 'Previous buffer' })
map('n', '<Leader>br', function() require('nvchad.tabufline').closeBufs_at_direction('right') end, { desc = 'Close all buffers to the right' })

for i = 1, 9, 1 do
  vim.keymap.set("n", string.format("<A-%s>", i), function()
    vim.api.nvim_set_current_buf(vim.t.bufs[i])
  end)
end

-- stylua: ignore end

-- map('n', '<Leader>c', function() require('jk.utils.buffer').close() end, { desc = 'Close buffer' })
-- map('n', '<Leader>C', function() require('jk.utils.buffer').close(0, true) end, { desc = 'Force close buffer' })
-- map('n', '<S-l>', function() require('jk.utils.buffer').nav(vim.v.count1) end, { desc = 'Next buffer' })
-- map('n', '<S-h>', function() require('jk.utils.buffer').nav(-vim.v.count1) end, { desc = 'Previous buffer' })
-- map('n', ']b', function() require('jk.utils.buffer').nav(vim.v.count1) end, { desc = 'Next buffer' })
-- map('n', '[b', function() require('jk.utils.buffer').nav(-vim.v.count1) end, { desc = 'Previous buffer' })
-- map('n', '>b', function() require('jk.utils.buffer').move(vim.v.count1) end, { desc = 'Move buffer tab right' })
-- map('n', '<b', function() require('jk.utils.buffer').move(-vim.v.count1) end, { desc = 'Move buffer tab left' })
--
-- map('n', '<Leader>bc', function() require('jk.utils.buffer').close_all(true) end, { desc = 'Close all buffers except current' })
-- map('n', '<Leader>bC', function() require('jk.utils.buffer').close_all() end, { desc = 'Close all buffers' })
-- map('n', '<Leader>bl', function() require('jk.utils.buffer').close_left() end, { desc = 'Close all buffers to the left' })
-- map('n', '<Leader>bp', function() require('jk.utils.buffer').prev() end, { desc = 'Previous buffer' })
-- map('n', '<Leader>br', function() require('jk.utils.buffer').close_right() end, { desc = 'Close all buffers to the right' })
