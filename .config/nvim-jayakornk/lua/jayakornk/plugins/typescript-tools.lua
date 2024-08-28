return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    end,
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
      'vue',
    },
    settings = {
      tsserver_plugins = {
        '@vue/language-server',
        '@vue/typescript-plugin',
      },
    },
  },
}
