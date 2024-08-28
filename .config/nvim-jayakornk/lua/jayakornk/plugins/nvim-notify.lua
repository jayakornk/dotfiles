return -- lazy.nvim
{
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  opts = {
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
    background_colour = '#1e222a',
    render = 'minimal',

    -- level = 2,
    -- background_colour = '#000000',
    -- render = 'wrapped-compact',
    -- max_width = 50,
  },
}
