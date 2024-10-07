M = {}

M.icons = {
  ActiveLSP = '',
  ActiveTS = '',
  ArrowLeft = '',
  ArrowRight = '',
  Bookmarks = '',
  BufferClose = '󰅖',
  DapBreakpoint = '',
  DapBreakpointCondition = '',
  DapBreakpointRejected = '',
  DapLogPoint = '󰛿',
  DapStopped = '󰁕',
  Debugger = '',
  DefaultFile = '󰈙',
  Diagnostic = '󰒡',
  DiagnosticError = '',
  DiagnosticHint = '',
  DiagnosticInfo = '',
  DiagnosticWarn = '',
  Ellipsis = '…',
  Environment = '',
  FileNew = '',
  FileModified = '',
  FileReadOnly = '',
  FoldClosed = '',
  FoldOpened = '',
  FoldSeparator = ' ',
  FolderClosed = '',
  FolderEmpty = '',
  FolderOpen = '',
  Git = '󰊢',
  GitAdd = '',
  GitBranch = '',
  GitChange = '',
  GitConflict = '',
  GitDelete = '',
  GitIgnored = '◌',
  GitRenamed = '➜',
  GitSign = '▎',
  GitStaged = '✓',
  GitUnstaged = '✗',
  GitUntracked = '★',
  List = '',
  LSPLoading1 = '',
  LSPLoading2 = '󰀚',
  LSPLoading3 = '',
  MacroRecording = '',
  Package = '󰏖',
  Paste = '󰅌',
  Refresh = '',
  Search = '',
  Selected = '❯',
  Session = '󱂬',
  Sort = '󰒺',
  Spellcheck = '󰓆',
  Tab = '󰓩',
  TabClose = '󰅙',
  Terminal = '',
  Window = '',
  WordFile = '󰈭',
  Trouble = '󱍼',
  Rest = '󰳘',
}

--- Get an icon from the AstroNvim internal icons if it is available and return it
---@param kind string The kind of icon in astroui.icons to retrieve
---@param padding? integer Padding to add to the end of the icon
---@param no_fallback? boolean Whether or not to disable fallback to text icon
---@return string icon
function M.get_icon(kind, padding, no_fallback)
  local icon = M.icons[kind]
  return icon and icon .. (' '):rep(padding or 0) or ''
end

return M
