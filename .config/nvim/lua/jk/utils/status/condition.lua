local M = {}

--- A condition function if the foldcolumn is enabled
---@return boolean # true if vim.opt.foldcolumn > 0, false if vim.opt.foldcolumn == 0
function M.foldcolumn_enabled()
  return vim.opt.foldcolumn:get() ~= '0'
end

--- A condition function if the number column is enabled
---@return boolean # true if vim.opt.number or vim.opt.relativenumber, false if neither
function M.numbercolumn_enabled()
  return vim.opt.number:get() or vim.opt.relativenumber:get()
end

--- A condition function if the signcolumn is enabled
---@return boolean # false if vim.opt.signcolumn == "no", true otherwise
function M.signcolumn_enabled()
  return vim.opt.signcolumn:get() ~= 'no'
end

return M
