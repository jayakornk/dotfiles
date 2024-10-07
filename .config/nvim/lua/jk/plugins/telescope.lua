return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons' },
  },
  keys = {
    {
      '<leader>,',
      '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>',
      desc = 'Switch Buffer',
    },
    {
      '<leader>/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end,
      desc = 'Grep (Root Dir)',
    },
    { '<leader>:', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
    -- find
    { '<leader>fb', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', desc = 'Buffers' },
    {
      '<leader>fc',
      function()
        require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = 'Find Config File',
    },
    { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find Files' },
    { '<leader>fg', '<cmd>Telescope git_files<cr>', desc = 'Find Files (git-files)' },
    { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent' },
    -- git
    { '<leader>gc', '<cmd>Telescope git_commits<CR>', desc = 'Commits' },
    { '<leader>gs', '<cmd>Telescope git_status<CR>', desc = 'Status' },
    -- search
    { '<leader>s"', '<cmd>Telescope registers<cr>', desc = 'Registers' },
    { '<leader>sa', '<cmd>Telescope autocommands<cr>', desc = 'Auto Commands' },
    { '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Buffer' },
    { '<leader>sc', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
    { '<leader>sC', '<cmd>Telescope commands<cr>', desc = 'Commands' },
    { '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = 'Document Diagnostics' },
    { '<leader>sD', '<cmd>Telescope diagnostics<cr>', desc = 'Workspace Diagnostics' },
    { '<leader>sg', '<cmd>Telescope live_grep<cr>', desc = 'Grep' },
    { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = 'Help Pages' },
    { '<leader>sH', '<cmd>Telescope highlights<cr>', desc = 'Search Highlight Groups' },
    { '<leader>sj', '<cmd>Telescope jumplist<cr>', desc = 'Jumplist' },
    { '<leader>sk', '<cmd>Telescope keymaps<cr>', desc = 'Key Maps' },
    { '<leader>sl', '<cmd>Telescope loclist<cr>', desc = 'Location List' },
    { '<leader>sM', '<cmd>Telescope man_pages<cr>', desc = 'Man Pages' },
    { '<leader>sm', '<cmd>Telescope marks<cr>', desc = 'Jump to Mark' },
    { '<leader>so', '<cmd>Telescope vim_options<cr>', desc = 'Options' },
    { '<leader>sR', '<cmd>Telescope resume<cr>', desc = 'Resume' },
    { '<leader>sq', '<cmd>Telescope quickfix<cr>', desc = 'Quickfix List' },
    { '<leader>sw', '<cmd>Telescope grep_string<cr>', desc = 'Word' },
  },
  opts = function()
    local actions, get_icon = require 'telescope.actions', require('jk/utils/icons').get_icon

    local open_with_trouble = function(...)
      return require('trouble.sources.telescope').open(...)
    end
    local find_files_no_ignore = function()
      local action_state = require 'telescope.actions.state'
      local line = action_state.get_current_line()
      require('telescope.builtin').find_files { no_ignore = true, default_text = line }
    end
    local find_files_with_hidden = function()
      local action_state = require 'telescope.actions.state'
      local line = action_state.get_current_line()
      require('telescope.builtin').find_files { hidden = true, default_text = line }
    end

    local function open_selected(prompt_bufnr)
      local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
      local selected = picker:get_multi_selection()
      if vim.tbl_isempty(selected) then
        actions.select_default(prompt_bufnr)
      else
        actions.close(prompt_bufnr)
        for _, file in pairs(selected) do
          if file.path then
            vim.cmd('edit' .. (file.lnum and ' +' .. file.lnum or '') .. ' ' .. file.path)
          end
        end
      end
    end
    local function open_all(prompt_bufnr)
      actions.select_all(prompt_bufnr)
      open_selected(prompt_bufnr)
    end

    local function find_command()
      if 1 == vim.fn.executable 'rg' then
        return { 'rg', '--files', '--color', 'never', '-g', '!.git' }
      elseif 1 == vim.fn.executable 'fd' then
        return { 'fd', '--type', 'f', '--color', 'never', '-E', '.git' }
      elseif 1 == vim.fn.executable 'fdfind' then
        return { 'fdfind', '--type', 'f', '--color', 'never', '-E', '.git' }
      elseif 1 == vim.fn.executable 'find' and vim.fn.has 'win32' == 0 then
        return { 'find', '.', '-type', 'f' }
      elseif 1 == vim.fn.executable 'where' then
        return { 'where', '/r', '.', '*' }
      end
    end

    return {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      defaults = {
        file_ignore_patterns = { '^%.git[/\\]', '[/\\]%.git[/\\]' },
        prompt_prefix = get_icon('Selected', 1),
        selection_caret = ' ',
        -- open files in the first window that is an actual file.
        -- use the current window if no other window is available.
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == '' then
              return win
            end
          end
          return 0
        end,
        multi_icon = get_icon('Selected', 1),
        path_display = { 'truncate' },
        sorting_strategy = 'ascending',
        layout_config = {
          horizontal = { prompt_position = 'top', preview_width = 0.55 },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = {
            ['<c-t>'] = open_with_trouble,
            ['<a-t>'] = open_with_trouble,
            ['<a-i>'] = find_files_no_ignore,
            ['<a-h>'] = find_files_with_hidden,
            ['<C-J>'] = actions.move_selection_next,
            ['<C-K>'] = actions.move_selection_previous,
            ['<CR>'] = open_selected,
            ['<M-CR>'] = open_all,
          },
          n = {
            q = actions.close,
            ['<CR>'] = open_selected,
            ['<M-CR>'] = open_all,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = find_command,
          file_ignore_patterns = { 'node_modules', '.git', '.venv' },
          hidden = true,
        },
      },
      live_grep = {
        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
        additional_args = function(_)
          return { '--hidden' }
        end,
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }
  end,
  config = function(_, opts)
    require('telescope').setup(opts)

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
  end,
  -- config = function()
  -- 	-- Telescope is a fuzzy finder that comes with a lot of different things that
  -- 	-- it can fuzzy find! It's more than just a "file finder", it can search
  -- 	-- many different aspects of Neovim, your workspace, LSP, and more!
  -- 	--
  -- 	-- The easiest way to use Telescope, is to start by doing something like:
  -- 	--  :Telescope help_tags
  -- 	--
  -- 	-- After running this command, a window will open up and you're able to
  -- 	-- type in the prompt window. You'll see a list of `help_tags` options and
  -- 	-- a corresponding preview of the help.
  -- 	--
  -- 	-- Two important keymaps to use while in Telescope are:
  -- 	--  - Insert mode: <c-/>
  -- 	--  - Normal mode: ?
  -- 	--
  -- 	-- This opens a window that shows you all of the keymaps for the current
  -- 	-- Telescope picker. This is really useful to discover what Telescope can
  -- 	-- do as well as how to actually do it!
  -- 	local actions, get_icon = require("telescope.actions"), require("jk/utils/icons").get_icon
  -- 	local function open_selected(prompt_bufnr)
  -- 		local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  -- 		local selected = picker:get_multi_selection()
  -- 		if vim.tbl_isempty(selected) then
  -- 			actions.select_default(prompt_bufnr)
  -- 		else
  -- 			actions.close(prompt_bufnr)
  -- 			for _, file in pairs(selected) do
  -- 				if file.path then
  -- 					vim.cmd("edit" .. (file.lnum and " +" .. file.lnum or "") .. " " .. file.path)
  -- 				end
  -- 			end
  -- 		end
  -- 	end
  -- 	local function open_all(prompt_bufnr)
  -- 		actions.select_all(prompt_bufnr)
  -- 		open_selected(prompt_bufnr)
  -- 	end
  -- 	local function find_command()
  -- 		if 1 == vim.fn.executable("rg") then
  -- 			return { "rg", "--files", "--color", "never", "-g", "!.git" }
  -- 		elseif 1 == vim.fn.executable("fd") then
  -- 			return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
  -- 		elseif 1 == vim.fn.executable("fdfind") then
  -- 			return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
  -- 		elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
  -- 			return { "find", ".", "-type", "f" }
  -- 		elseif 1 == vim.fn.executable("where") then
  -- 			return { "where", "/r", ".", "*" }
  -- 		end
  -- 	end
  --
  -- 	-- [[ Configure Telescope ]]
  -- 	-- See `:help telescope` and `:help telescope.setup()`
  -- 	require("telescope").setup({
  -- 		-- You can put your default mappings / updates / etc. in here
  -- 		--  All the info you're looking for is in `:help telescope.setup()`
  -- 		defaults = {
  -- 			file_ignore_patterns = { "^%.git[/\\]", "[/\\]%.git[/\\]" },
  -- 			prompt_prefix = get_icon("Selected", 1),
  -- 			selection_caret = get_icon("Selected", 1),
  -- 			multi_icon = get_icon("Selected", 1),
  -- 			path_display = { "truncate" },
  -- 			sorting_strategy = "ascending",
  -- 			layout_config = {
  -- 				horizontal = { prompt_position = "top", preview_width = 0.55 },
  -- 				vertical = { mirror = false },
  -- 				width = 0.87,
  -- 				height = 0.80,
  -- 				preview_cutoff = 120,
  -- 			},
  -- 			mappings = {
  -- 				i = {
  -- 					["<C-J>"] = actions.move_selection_next,
  -- 					["<C-K>"] = actions.move_selection_previous,
  -- 					["<CR>"] = open_selected,
  -- 					["<M-CR>"] = open_all,
  -- 				},
  -- 				n = {
  -- 					q = actions.close,
  -- 					["<CR>"] = open_selected,
  -- 					["<M-CR>"] = open_all,
  -- 				},
  -- 			},
  -- 		},
  -- 		pickers = {
  -- 			find_files = {
  -- 				find_command = find_command,
  -- 				file_ignore_patterns = { "node_modules", ".git", ".venv" },
  -- 				hidden = true,
  -- 			},
  -- 		},
  -- 		live_grep = {
  -- 			file_ignore_patterns = { "node_modules", ".git", ".venv" },
  -- 			additional_args = function(_)
  -- 				return { "--hidden" }
  -- 			end,
  -- 		},
  -- 		extensions = {
  -- 			["ui-select"] = {
  -- 				require("telescope.themes").get_dropdown(),
  -- 			},
  -- 		},
  -- 	})
  --
  -- 	-- Enable Telescope extensions if they are installed
  -- 	-- pcall(require("telescope").load_extension, "fzf")
  -- 	-- pcall(require("telescope").load_extension, "ui-select")
  --
  -- 	-- -- See `:help telescope.builtin`
  -- 	-- local builtin = require("telescope.builtin")
  -- 	-- vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
  -- 	-- vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
  -- 	-- vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
  -- 	-- vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
  -- 	-- vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
  -- 	-- vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
  -- 	-- vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
  -- 	-- vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
  -- 	-- vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  -- 	-- vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
  -- 	--
  -- 	-- -- Slightly advanced example of overriding default behavior and theme
  -- 	-- vim.keymap.set("n", "<leader>/", function()
  -- 	-- 	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
  -- 	-- 	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
  -- 	-- 		winblend = 10,
  -- 	-- 		previewer = false,
  -- 	-- 	}))
  -- 	-- end, { desc = "[/] Fuzzily search in current buffer" })
  -- 	--
  -- 	-- -- It's also possible to pass additional configuration options.
  -- 	-- --  See `:help telescope.builtin.live_grep()` for information about particular keys
  -- 	-- vim.keymap.set("n", "<leader>s/", function()
  -- 	-- 	builtin.live_grep({
  -- 	-- 		grep_open_files = true,
  -- 	-- 		prompt_title = "Live Grep in Open Files",
  -- 	-- 	})
  -- 	-- end, { desc = "[S]earch [/] in Open Files" })
  -- 	--
  -- 	-- -- Shortcut for searching your Neovim configuration files
  -- 	-- vim.keymap.set("n", "<leader>sn", function()
  -- 	-- 	builtin.find_files({ cwd = vim.fn.stdpath("config") })
  -- 	-- end, { desc = "[S]earch [N]eovim files" })
  -- end,
}
