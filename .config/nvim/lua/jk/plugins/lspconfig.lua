return {
  'neovim/nvim-lspconfig',
  lazy = false,
  cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
  -- event = {'BufReadPre', 'BufNewFile'},
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    local lsp_zero = require 'lsp-zero'
    local get_icon = require('jk.utils.icons').get_icon

    -- lsp_attach is where you enable features that only work
    -- if there is a language server active in the file
    local lsp_attach = function(client, bufnr)
      lsp_zero.default_keymaps {
        buffer = bufnr,
        preserve_mappings = false,
      }

      local map = function(keys, func, opts)
        local mode = opts.mode or 'n'
        opts.mode = nil
        local o = vim.tbl_deep_extend('force', { buffer = bufnr, desc = opts.desc }, opts)
        vim.keymap.set(mode, keys, func, o)
      end

      map('<leader>ll', '<cmd>LspInfo<cr>', { desc = 'Lsp Info' })
      map('gd', vim.lsp.buf.definition, { desc = 'Goto Definition' })
      map('gr', vim.lsp.buf.references, { desc = 'References', nowait = true })
      map('gI', vim.lsp.buf.implementation, { desc = 'Goto Implementation' })
      map('gy', vim.lsp.buf.type_definition, { desc = 'Goto T[y]pe Definition' })
      map('gD', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
      map('K', vim.lsp.buf.hover, { desc = 'Hover' })
      map('gK', vim.lsp.buf.signature_help, { desc = 'Signature Help' })
      map('<c-k>', vim.lsp.buf.signature_help, { desc = 'Signature Help', mode = 'i' })
      map('<leader>la', vim.lsp.buf.code_action, { desc = 'Code Action', mode = { 'n', 'v' } })
      map('<leader>lc', vim.lsp.codelens.run, { desc = 'Run Codelens', mode = { 'n', 'v' } })
      map('<leader>lC', vim.lsp.codelens.refresh, { desc = 'Refresh & Display Codelens', mode = { 'n' } })
      --   map( "<leader>cR", LazyVim.lsp.rename_file, {desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" }})
      -- map("<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
      map('<leader>lr', function()
        local inc_rename = require 'inc_rename'
        return ':' .. inc_rename.config.cmd_name .. ' ' .. vim.fn.expand '<cword>'
      end, { desc = 'Rename (inc-rename.nvim)', expr = true })
      --   map( "<leader>cA", LazyVim.lsp.action.source, {desc = "Source Action", has = "codeAction"})
    end

    local lsp_capabilities = vim.tbl_deep_extend('force', require('cmp_nvim_lsp').default_capabilities(), {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    })

    lsp_zero.extend_lspconfig {
      sign_text = {
        error = get_icon 'DiagnosticError',
        warn = get_icon 'DiagnosticWarn',
        hint = get_icon 'DiagnosticHint',
        info = get_icon 'DiagnosticInfo',
      },
      lsp_attach = lsp_attach,
      float_border = 'rounded',
      capabilities = lsp_capabilities,
    }

    local servers = {
      'lua_ls',
      'gopls',
    }

    local ensure_installed = servers
    vim.list_extend(ensure_installed, {
      'stylua',
      'gofumpt',
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      -- ensure_installed = {},
      handlers = {
        -- this first function is the "default handler"
        -- it applies to every language server without a "custom handler"
        function(server_name)
          require('lspconfig')[server_name].setup {}
        end,
        lua_ls = function()
          require('lspconfig').lua_ls.setup {
            on_init = function(client)
              lsp_zero.nvim_lua_settings(client, {})
            end,
          }
        end,
      },
    }
  end,
}
