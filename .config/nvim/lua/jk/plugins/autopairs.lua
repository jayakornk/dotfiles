return {
  'windwp/nvim-autopairs',
  opts = {
    check_ts = true,
    ts_config = { java = false },
    fast_wrap = {
      map = '<M-e>',
      chars = { '{', '[', '(', '"', "'" },
      pattern = ([[ [%'%"%)%>%]%)%}%,] ]]):gsub('%s+', ''),
      offset = 0,
      end_key = '$',
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      check_comma = true,
      highlight = 'PmenuSel',
      highlight_grey = 'LineNr',
    },
    disable_filetype = { 'TelescopePrompt', 'vim' },
  },
  config = function(_, opts)
    require('nvim-autopairs').setup(opts)

    -- setup cmp for autopairs
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
