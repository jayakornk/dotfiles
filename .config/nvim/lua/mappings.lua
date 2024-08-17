require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

local unmap = vim.keymap.del

--- This fixes an issue with the vim-tmux-navigator + nvchad in which the base nvchad
--- mapping were conflicting with vim-tmux-navigator ones.
unmap("n", "<c-h>")
unmap("n", "<c-j>")
unmap("n", "<c-k>")
unmap("n", "<c-l>")
map("n", "<c-h>", "<cmd>:TmuxNavigateLeft<cr>", { desc = "switch window left" })
map("n", "<c-j>", "<cmd>:TmuxNavigateDown<cr>", { desc = "switch window down" })
map("n", "<c-k>", "<cmd>:TmuxNavigateUp<cr>", { desc = "switch window up" })
map("n", "<c-l>", "<cmd>:TmuxNavigateRight<cr>", { desc = "switch window right" })
map("n", "<c-\\>", "<cmd>:TmuxNavigatePrevious<cr>")
