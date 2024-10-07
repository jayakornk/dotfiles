return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    { 'kevinhwang91/promise-async', lazy = true },
    {
      'luukvbaal/statuscol.nvim',
      config = function()
        local builtin = require 'statuscol.builtin'
        require('statuscol').setup {
          relculright = true,
          segments = {
            { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
            -- { text = { "%s" }, click = "v:lua.ScSa" },
            {
              sign = { namespace = { 'diagnostic/signs' }, maxwidth = 2, colwidth = 1, auto = false },
              click = 'v:lua.ScSa',
            },
            { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
            {
              sign = { namespace = { 'gitsigns' }, maxwidth = 2, colwidth = 1, auto = false },
              click = 'v:lua.ScSa',
            },
            {
              sign = { name = { '.*' }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
              click = 'v:lua.ScSa',
            },
          },
        }
      end,
    },
  },
  event = 'BufReadPost',
	-- stylua: ignore
	keys = {
		{ "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
		{ "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
		{ "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Fold less" },
		{ "zm", function() require("ufo").closeFoldsWith() end, desc = "Fold more" },
		{ "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek fold" },
	},
  init = function()
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    vim.o.foldcolumn = '1' -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  opts = {
    preview = {
      mappings = {
        scrollB = '<C-B>',
        scrollF = '<C-F>',
        scrollU = '<C-U>',
        scrollD = '<C-D>',
      },
    },
    provider_selector = function(_, filetype, buftype)
      local function handleFallbackException(bufnr, err, providerName)
        if type(err) == 'string' and err:match 'UfoFallbackException' then
          return require('ufo').getFolds(bufnr, providerName)
        else
          return require('promise').reject(err)
        end
      end

      return (filetype == '' or buftype == 'nofile') and 'indent' -- only use indent until a file is opened
        or function(bufnr)
          return require('ufo')
            .getFolds(bufnr, 'lsp')
            :catch(function(err)
              return handleFallbackException(bufnr, err, 'treesitter')
            end)
            :catch(function(err)
              return handleFallbackException(bufnr, err, 'indent')
            end)
        end
    end,
  },
  config = function(_, opts)
    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local totalLines = vim.api.nvim_buf_line_count(0)
      local foldedLines = endLnum - lnum
      local suffix = (' 󰁂 %d %d%%'):format(foldedLines, foldedLines / totalLines * 100)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      local rAlignAppndx = math.max(math.min(vim.api.nvim_win_get_width(0), width - 1) - curWidth - sufWidth, 0)
      suffix = (' '):rep(rAlignAppndx) .. suffix
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end
    opts['fold_virt_text_handler'] = handler
    require('ufo').setup(opts)
  end,
}
