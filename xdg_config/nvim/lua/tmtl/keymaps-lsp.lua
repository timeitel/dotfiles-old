local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

function Goto_Diagnostic(opts)
  local table_length = require("tmtl.utils").table_length
  opts = opts or {}
  local prev = opts.prev or false
  local float = opts.float or false

  if prev then
    vim.diagnostic.goto_prev({ float = false, severity = opts.severity })
  else
    vim.diagnostic.goto_next({ float = false, severity = opts.severity })
  end

  if float then
    vim.defer_fn(function()
      vim.diagnostic.open_float(0, { severity_sort = true, border = border })
    end, 50)
  end

  local diagnostic_count = table_length(vim.diagnostic.get(0))
  if diagnostic_count == 0 then
    require("notify")("No more diagnostics")
  else
    vim.fn.feedkeys("zz")
  end
end

local M = {}

M.attach = function(bufnr)
  local function buf_map(m, k, v, d)
    vim.keymap.set(m, k, v, { noremap = true, silent = true, buffer = bufnr or 0, desc = d })
  end

  -- Diagnostics
  buf_map("n", "]e", function()
    Goto_Diagnostic({ severity = vim.diagnostic.severity.ERROR })
  end, "Next [E]rror")

  buf_map("n", "[e", function()
    Goto_Diagnostic({ prev = true, severity = vim.diagnostic.severity.ERROR })
  end, "Previous [E]rror")

  buf_map("n", "<C-n>", function()
    Goto_Diagnostic({ float = true, severity = { min = vim.diagnostic.severity.HINT } })
  end, "Next [D]iagnostic")

  buf_map("n", "]d", function()
    Goto_Diagnostic()
  end, "Next [D]iagnostic")

  buf_map("n", "[d", function()
    Goto_Diagnostic({ prev = true })
  end, "Previous [D]iagnostic")

  buf_map("n", "<leader>la", function()
    vim.lsp.buf.code_action()
  end, "[L]SP code [A]ctions")

  buf_map("n", "<leader>lh", function()
    vim.diagnostic.open_float(0, { border = border })
  end, "[L]SP [H]over")

  -- LSP
  buf_map("n", "<leader>lr", function()
    vim.lsp.buf.rename()
  end, "[L]SP [R]ename")

  buf_map("n", "<leader>li", function()
    vim.cmd([[OrganizeImports]])
  end, "[L]SP organize [I]mports")

  buf_map("n", "<leader><leader>lr", function()
    vim.cmd([[LspRestart]])
  end, "[L]SP [R]estart")

  buf_map("n", "<leader><leader>li", function()
    vim.cmd([[LspInfo]])
  end, "[L]SP [I]nfo")

  buf_map("n", "<leader><leader>ls", function()
    -- TODO: change to toggle with ls, check if needing to stop or start
    vim.cmd([[LspStop]])
  end, "[L]SP [S]top")

  buf_map("n", "<leader><leader>lr", function()
    vim.cmd([[LspRestart]])
  end, "[L]SP [R]estart")

  buf_map({ "i", "n" }, "<C-S-Space>", function()
    vim.lsp.buf.signature_help()
  end, "Lsp signature")

  buf_map("n", "gd", function()
    -- TODO: look into awaiting definition before centering
    vim.lsp.buf.definition()

    vim.defer_fn(function()
      vim.fn.feedkeys("zz")
    end, 100)
  end, "Lsp [G]o to [D]efinition")

  buf_map("n", "gov", function()
    -- TODO: look into awaiting definition before centering
    vim.cmd([[only]])
    vim.cmd([[vs]])
    vim.lsp.buf.definition()

    vim.defer_fn(function()
      vim.fn.feedkeys("zz")
    end, 100)
  end, "Lsp [G]o to [D]efinition in vertical split")

  buf_map("n", "K", function()
    vim.lsp.buf.hover()
  end, "Lsp Hover")

  buf_map("n", "R", function()
    require("telescope.builtin").lsp_references({ show_line = false, include_declaration = false })
  end, "Lsp [R]eferences")

  buf_map("n", "gt", function()
    vim.lsp.buf.type_definition()
    vim.fn.feedkeys("zz")
  end, "Lsp [G]o to [T]ype definition")

  buf_map("n", "gI", function()
    vim.lsp.buf.implementation()
    vim.fn.feedkeys("zz")
  end, "Lsp [G]o to [I]mplementation")
end

return M
