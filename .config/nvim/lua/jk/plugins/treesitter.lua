return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  dependencies = { { 'nvim-treesitter/nvim-treesitter-textobjects', lazy = true } },
  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treeitter** module to be loaded in time.
    -- Luckily, the only thins that those plugins need are the custom queries, which we make available
    -- during startup.
    -- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
    require('lazy.core.loader').add_to_rtp(plugin)
    pcall(require, 'nvim-treesitter.query_predicates')
  end,
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
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['ak'] = { query = '@block.outer', desc = 'around block' },
          ['ik'] = { query = '@block.inner', desc = 'inside block' },
          ['ac'] = { query = '@class.outer', desc = 'around class' },
          ['ic'] = { query = '@class.inner', desc = 'inside class' },
          ['a?'] = { query = '@conditional.outer', desc = 'around conditional' },
          ['i?'] = { query = '@conditional.inner', desc = 'inside conditional' },
          ['af'] = { query = '@function.outer', desc = 'around function ' },
          ['if'] = { query = '@function.inner', desc = 'inside function ' },
          ['ao'] = { query = '@loop.outer', desc = 'around loop' },
          ['io'] = { query = '@loop.inner', desc = 'inside loop' },
          ['aa'] = { query = '@parameter.outer', desc = 'around argument' },
          ['ia'] = { query = '@parameter.inner', desc = 'inside argument' },
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']k'] = { query = '@block.outer', desc = 'Next block start' },
          [']f'] = { query = '@function.outer', desc = 'Next function start' },
          [']a'] = { query = '@parameter.inner', desc = 'Next argument start' },
        },
        goto_next_end = {
          [']K'] = { query = '@block.outer', desc = 'Next block end' },
          [']F'] = { query = '@function.outer', desc = 'Next function end' },
          [']A'] = { query = '@parameter.inner', desc = 'Next argument end' },
        },
        goto_previous_start = {
          ['[k'] = { query = '@block.outer', desc = 'Previous block start' },
          ['[f'] = { query = '@function.outer', desc = 'Previous function start' },
          ['[a'] = { query = '@parameter.inner', desc = 'Previous argument start' },
        },
        goto_previous_end = {
          ['[K'] = { query = '@block.outer', desc = 'Previous block end' },
          ['[F'] = { query = '@function.outer', desc = 'Previous function end' },
          ['[A'] = { query = '@parameter.inner', desc = 'Previous argument end' },
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['>K'] = { query = '@block.outer', desc = 'Swap next block' },
          ['>F'] = { query = '@function.outer', desc = 'Swap next function' },
          ['>A'] = { query = '@parameter.inner', desc = 'Swap next argument' },
        },
        swap_previous = {
          ['<K'] = { query = '@block.outer', desc = 'Swap previous block' },
          ['<F'] = { query = '@function.outer', desc = 'Swap previous function' },
          ['<A'] = { query = '@parameter.inner', desc = 'Swap previous argument' },
        },
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
-- 	-- main = "nvim-treesitter.configs",
-- 	version = false,
-- 	-- dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true } },
-- 	event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
-- 	lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
-- 	cmd = {
-- 		"TSBufDisable",
-- 		"TSBufEnable",
-- 		"TSBufToggle",
-- 		"TSDisable",
-- 		"TSEnable",
-- 		"TSToggle",
-- 		"TSInstall",
-- 		"TSInstallInfo",
-- 		"TSInstallSync",
-- 		"TSModuleInfo",
-- 		"TSUninstall",
-- 		"TSUpdate",
-- 		"TSUpdateSync",
-- 	},
-- 	build = ":TSUpdate",
-- 	init = function(plugin)
-- 		-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
-- 		-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
-- 		-- no longer trigger the **nvim-treeitter** module to be loaded in time.
-- 		-- Luckily, the only thins that those plugins need are the custom queries, which we make available
-- 		-- during startup.
-- 		-- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
-- 		require("lazy.core.loader").add_to_rtp(plugin)
-- 		pcall(require, "nvim-treesitter.query_predicates")
-- 	end,
-- 	opts_extend = { "ensure_installed" },
-- 	opts = function()
-- 		-- require("lazy").load({ plugins = { "mason.nvim" } })
-- 		return {
-- 			-- auto_install = vim.fn.executable("git") == 1 and vim.fn.executable("tree-sitter") == 1, -- only enable auto install if `tree-sitter` cli is installed
-- 			auto_install = true,
-- 			ensure_installed = { "bash", "c", "lua", "markdown", "markdown_inline", "python", "query", "vim", "vimdoc" },
-- 			highlight = { enable = true },
-- 			incremental_selection = { enable = true },
-- 			indent = { enable = true },
-- 			-- textobjects = {
-- 			-- 	select = {
-- 			-- 		enable = true,
-- 			-- 		lookahead = true,
-- 			-- 		keymaps = {
-- 			-- 			["ak"] = { query = "@block.outer", desc = "around block" },
-- 			-- 			["ik"] = { query = "@block.inner", desc = "inside block" },
-- 			-- 			["ac"] = { query = "@class.outer", desc = "around class" },
-- 			-- 			["ic"] = { query = "@class.inner", desc = "inside class" },
-- 			-- 			["a?"] = { query = "@conditional.outer", desc = "around conditional" },
-- 			-- 			["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
-- 			-- 			["af"] = { query = "@function.outer", desc = "around function " },
-- 			-- 			["if"] = { query = "@function.inner", desc = "inside function " },
-- 			-- 			["ao"] = { query = "@loop.outer", desc = "around loop" },
-- 			-- 			["io"] = { query = "@loop.inner", desc = "inside loop" },
-- 			-- 			["aa"] = { query = "@parameter.outer", desc = "around argument" },
-- 			-- 			["ia"] = { query = "@parameter.inner", desc = "inside argument" },
-- 			-- 		},
-- 			-- 	},
-- 			-- 	move = {
-- 			-- 		enable = true,
-- 			-- 		set_jumps = true,
-- 			-- 		goto_next_start = {
-- 			-- 			["]k"] = { query = "@block.outer", desc = "Next block start" },
-- 			-- 			["]f"] = { query = "@function.outer", desc = "Next function start" },
-- 			-- 			["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
-- 			-- 		},
-- 			-- 		goto_next_end = {
-- 			-- 			["]K"] = { query = "@block.outer", desc = "Next block end" },
-- 			-- 			["]F"] = { query = "@function.outer", desc = "Next function end" },
-- 			-- 			["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
-- 			-- 		},
-- 			-- 		goto_previous_start = {
-- 			-- 			["[k"] = { query = "@block.outer", desc = "Previous block start" },
-- 			-- 			["[f"] = { query = "@function.outer", desc = "Previous function start" },
-- 			-- 			["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
-- 			-- 		},
-- 			-- 		goto_previous_end = {
-- 			-- 			["[K"] = { query = "@block.outer", desc = "Previous block end" },
-- 			-- 			["[F"] = { query = "@function.outer", desc = "Previous function end" },
-- 			-- 			["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
-- 			-- 		},
-- 			-- 	},
-- 			-- 	swap = {
-- 			-- 		enable = true,
-- 			-- 		swap_next = {
-- 			-- 			[">K"] = { query = "@block.outer", desc = "Swap next block" },
-- 			-- 			[">F"] = { query = "@function.outer", desc = "Swap next function" },
-- 			-- 			[">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
-- 			-- 		},
-- 			-- 		swap_previous = {
-- 			-- 			["<K"] = { query = "@block.outer", desc = "Swap previous block" },
-- 			-- 			["<F"] = { query = "@function.outer", desc = "Swap previous function" },
-- 			-- 			["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
-- 			-- 		},
-- 			-- 	},
-- 			-- },
-- 		}
-- 	end,
-- }
