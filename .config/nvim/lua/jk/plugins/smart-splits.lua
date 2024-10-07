local term = vim.trim((vim.env.TERM_PROGRAM or ''):lower())
local mux = term == 'tmux' or term == 'wezterm' or vim.env.KITTY_LISTEN_ON

return {
  'mrjones2014/smart-splits.nvim',
  lazy = true,
  event = mux and 'VeryLazy' or nil, -- load early if mux detected
  -- stylua: ignore
  keys = {
    { "<C-H>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left split" },
    { "<C-J>", function() require("smart-splits").move_cursor_down() end, desc = "Move to below split" },
    { "<C-K>", function() require("smart-splits").move_cursor_up() end, desc = "Move to above split" },
    { "<C-L>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" },
    { "<Up>", function() require("smart-splits").resize_up() end, desc = "Resize split up" },
    { "<Down>", function() require("smart-splits").resize_down() end, desc = "Resize split down" },
    { "<Left>", function() require("smart-splits").resize_left() end, desc = "Resize split left" },
    { "<Right>", function() require("smart-splits").resize_right() end, desc = "Resize split right" },
  },
  opts = { ignored_filetypes = { 'nofile', 'quickfix', 'qf', 'prompt' }, ignored_buftypes = { 'nofile' } },
}
