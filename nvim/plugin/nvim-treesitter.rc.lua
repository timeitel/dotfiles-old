local status, ts = pcall(require, "nvim-treesitter.configs")
if not status then
  return
end

ts.setup({
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    "tsx",
    "json",
    "yaml",
    "css",
    "html",
    "lua",
  },
  autotag = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
      include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      set_jumps = false,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]a"] = "@parameter.outer",
      },
      goto_next_end = {},
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[a"] = "@parameter.outer",
      },
      goto_previous_end = {},
    },
    lsp_interop = {
      enable = true,
      border = "none",
      peek_definition_code = {
        ["<leader>pf"] = "@function.outer", -- preview function
        -- TODO: open preview in split
      },
    },
  },
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
