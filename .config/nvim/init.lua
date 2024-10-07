require 'jk.core.options'
require 'jk.core.keymaps'
require 'jk.core.autocmd'

vim.g.base46_cache = vim.fn.stdpath 'data' .. '/base46_cache/'
require 'jk.lazy'

-- vim.api.nvim_set_hl(0, "FoldColumn", {
-- 	bg = "",
-- })
