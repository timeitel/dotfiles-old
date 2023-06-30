local M = {
  "nvim-lualine/lualine.nvim",
  config = function()
    local kanagawa_colors = require("kanagawa.colors").setup()
    local palette_colors = kanagawa_colors.palette
    local theme_colors = kanagawa_colors.theme
    local lualine = require("lualine")

    local colors = {
      blue = palette_colors.crystalBlue,
      gray = palette_colors.sumiInk3,
      green = palette_colors.autumnGreen,
      gunmetal = "#282c34",
      yellow = palette_colors.autumnYellow,
      magenta = palette_colors.crystalBlue,
      cyan = palette_colors.dragonBlue,
    }
    local secondary_blue = { bg = colors.blue, fg = colors.gray }

    local function get_normal_mode_colors(primary)
      local color = { bg = colors.gray, fg = primary }
      return {
        a = color,
        b = color,
        c = { bg = colors.gunmetal, fg = theme_colors.syn.comment },
        x = color,
        y = color,
        -- z = { bg = primary, fg = colors.gray },
      }
    end

    local function get_mode_colors(primary)
      local color = { bg = colors.gunmetal, fg = primary }
      return {
        a = color,
        b = color,
        x = color,
        y = color,
        -- z = { bg = colors.gunmetal, fg = primary },
      }
    end

    local theme = {
      normal = get_normal_mode_colors(colors.blue),
      insert = get_mode_colors(colors.magenta),
      visual = get_mode_colors(colors.magenta),
      replace = get_mode_colors(colors.cyan),
      command = get_mode_colors(colors.yellow),
    }

    local global_line_filename = {
      "filename",
      -- TODO: either show cursor diff3rent in insert mode in terminal or add mode to lualine
      separator = { left = "", right = "" },
      fmt = function(str)
        if string.find(str, 'zsh;') ~= nil then
          return "Terminal"
        end
        return str
      end
    }

    local winbar_filename = {
      "filename",
      path = 1,
      separator = { left = "", right = "" },
      color = secondary_blue,
      fmt = function(str)
        if (string.find(str, '.git/') ~= nil or string.find(str, '/worktrees/') ~= nil) and
            string.find(str, ':3:/') ~= nil then
          return "THEIRS"
        end

        if (string.find(str, '.git/') ~= nil or string.find(str, '/worktrees/') ~= nil)
            and string.find(str, ':2:/') ~= nil then
          return "OURS"
        end

        if string.find(str, 'term://') ~= nil then
          return ""
        end

        return str
      end
    }

    local winbar_inactive_filename = {
      "filename",
      separator = { left = "", right = "" },
      path = 1,
      fmt = function(str)
        if (string.find(str, '.git/') ~= nil or string.find(str, '/worktrees/') ~= nil) and
            string.find(str, ':3:/') ~= nil then
          return "THEIRS"
        end

        if (string.find(str, '.git/') ~= nil or string.find(str, '/worktrees/') ~= nil)
            and string.find(str, ':2:/') ~= nil then
          return "OURS"
        end

        if string.find(str, 'term://') ~= nil then
          return ""
        end

        return str
      end,
      color = { bg = colors.gray, fg = colors.blue },
    }

    local filetype = {
      "filetype",
      icon_only = true,
      colored = false,
      padding = { right = 0, left = 2 },
      separator = { left = "", right = "" },
    }

    local branch = {
      "branch",
      separator = { left = "", right = "" },
      color = secondary_blue,
    }

    local diagnostic_stats = {
      "diagnostics",
      colored = false,
      separator = { left = "", right = "" },
    }

    local function get_current_line_diagnostic()
      local bufnr = 0
      local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
      local opts = { ["lnum"] = line_nr }

      local line_diagnostics = vim.diagnostic.get(bufnr, opts)
      if vim.tbl_isempty(line_diagnostics) then
        return
      end

      local best_diagnostic = nil

      for _, diagnostic in ipairs(line_diagnostics) do
        if best_diagnostic == nil or diagnostic.severity < best_diagnostic.severity then
          best_diagnostic = diagnostic
        end
      end

      return best_diagnostic
    end

    local line_diagnostic = {
      function()
        local diagnostic = get_current_line_diagnostic()

        if not diagnostic or not diagnostic.message then
          return ""
        end

        local message = vim.split(diagnostic.message, "\n")[1]
        local max_width = vim.api.nvim_win_get_width(0) - 35

        if string.len(message) < max_width then
          return message
        else
          return string.sub(message, 1, max_width) .. "..."
        end
      end,
    }

    local lsp = {
      function()
        local msg = "No LSP"
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
          return msg
        end
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return "  " .. client.name
          end
        end
        return "  " .. msg
      end,
      separator = { left = "", right = "" },
      color = secondary_blue,
    }

    local search_count = {
      function()
        -- searchcount can fail e.g. if unbalanced braces in search pattern
        if vim.v.hlsearch == 1 then
          local ok, searchcount = pcall(vim.fn.searchcount)

          if ok and searchcount["total"] > 0 then
            return "⚲ " .. searchcount["current"] .. "/" .. searchcount["total"] .. " "
          end
        end

        return ""
      end,
      separator = { left = "", right = "" },
      color = secondary_blue,
    }

    local macro_recording = {
      function()
        local recording_register = vim.fn.reg_recording()

        if recording_register == "" then
          return ""
        else
          return "rec @" .. recording_register .. " "
        end
      end,
      separator = { left = "", right = "" },
    }

    local lsp_progress = {
      "lsp_progress",
      display_components = { { "title", "percentage" } },
      timer = { progress_enddelay = 1000, lsp_client_name_enddelay = 1000 },
    }

    local worktree = {
      function()
        return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end,
      color = secondary_blue,
    }

    lualine.setup({
      options = {
        theme = theme,
        icons_enabled = true,
        disabled_filetypes = {
          statusline = { "DiffviewFiles", "DiffviewFileHistory" },
          winbar = { "DiffviewFiles", "DiffviewFileHistory" },
        },
        ignore_focus = {},
        always_divide_middle = false,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { worktree, branch },
        lualine_b = { filetype, global_line_filename },
        lualine_c = { line_diagnostic },
        lualine_x = { search_count, macro_recording },
        lualine_y = { diagnostic_stats },
        lualine_z = { lsp, lsp_progress },
      },
      inactive_sections = {},
      tabline = {},
      winbar = {
        lualine_z = { winbar_filename },
      },
      inactive_winbar = {
        lualine_x = { diagnostic_stats },
        lualine_z = { winbar_inactive_filename },
      },
      extensions = {},
    })
  end,
}

return M
