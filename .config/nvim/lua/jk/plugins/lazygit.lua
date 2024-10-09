return {
  'kdheepak/lazygit.nvim',
  lazy = true,
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- optional for floating window border decoration
  dependencies = {
    -- "nvim-telescope/telescope.nvim",
    'nvim-lua/plenary.nvim',
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { '<leader>gg', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit' },
    { '<leader>gl', '<cmd>LazyGitFilter<cr>', desc = 'LazyGit log' },
  },
  -- init = function()
  --   vim.g.lazygit_floating_window_use_plenary = 1 -- use plenary.nvim to manage floating window if available
  -- end,
  -- config = function()
  -- 	require("telescope").load_extension("lazygit")
  -- end,
}
