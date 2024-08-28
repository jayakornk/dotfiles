return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  dependencies = {
    'windwp/nvim-ts-autotag',
  },

  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'regex',
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    -- enable indentation
    -- enable autotagging (w/ nvim-ts-autotag plugin)
    autotag = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>',
        node_incremental = '<C-space>',
        scope_incremental = false,
        node_decremental = '<bs>',
      },
    },
  },
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}

-- return {
-- 	"nvim-treesitter/nvim-treesitter",
-- 	event = { "BufReadPre", "BufNewFile" },
-- 	build = ":TSUpdate",
-- 	dependencies = {
-- 		"windwp/nvim-ts-autotag",
-- 	},
-- 	config = function()
-- 		-- import nvim-treesitter plugin
-- 		local treesitter = require("nvim-treesitter.configs")
--
-- 		-- configure treesitter
-- 		treesitter.setup({
-- 			-- enable syntax highlighting
-- 			auto_install = true,
-- 			highlight = {
-- 				enable = true,
-- 				additional_vim_regex_highlighting = false,
-- 			},
-- 			-- enable indentation
-- 			indent = { enable = true },
-- 			-- enable autotagging (w/ nvim-ts-autotag plugin)
-- 			autotag = {
-- 				enable = true,
-- 			},
-- 			-- ensure these language parsers are installed
-- 			ensure_installed = {
-- 				"json",
-- 				"javascript",
-- 				"typescript",
-- 				"tsx",
-- 				"yaml",
-- 				"html",
-- 				"css",
-- 				"markdown",
-- 				"markdown_inline",
-- 				"bash",
-- 				"lua",
-- 				"vim",
-- 				"dockerfile",
-- 				"gitignore",
-- 				"query",
-- 				"vimdoc",
-- 			},
-- 			incremental_selection = {
-- 				enable = true,
-- 				keymaps = {
-- 					init_selection = "<C-space>",
-- 					node_incremental = "<C-space>",
-- 					scope_incremental = false,
-- 					node_decremental = "<bs>",
-- 				},
-- 			},
-- 		})
-- 	end,
-- }
