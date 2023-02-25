-- TODO: C-O and C-I to go forward and back in file browser
local telescope = require("telescope")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")
local notify = require("notify")
local fb_actions = telescope.extensions.file_browser.actions
local copy = require("tmtl.utils").shallow_copy

-- Telescope defaults
local default_insert_mappings = {
  ["<C-j>"] = actions.move_selection_next,
  ["<C-k>"] = actions.move_selection_previous,
  ["<C-q>"] = actions.close,
  ["<C-l>"] = actions.select_default + actions.center,
  ["<C-h>"] = function()
    vim.api.nvim_input("<BS>")
  end,
  ["<C-w>"] = function()
    vim.api.nvim_input("<c-s-w>")
  end,
  ["<C-s>"] = actions.select_horizontal,
  ["<M-p>"] = actions_layout.toggle_preview,
}

local default_normal_mappings = copy(default_insert_mappings)
default_normal_mappings["<leader>qf"] = function(bfnr)
  actions.send_to_qflist(bfnr)
  vim.cmd([[copen]])
end
default_normal_mappings["c"] = false
default_normal_mappings["q"] = actions.close
default_normal_mappings["l"] = actions.select_default + actions.center

-- Telescope File-browser
local file_browser_normal_mappings = {
  ["<leader>yf"] = function()
    local entry = action_state.get_selected_entry()
    local copy_filename_cmd = string.format(':let @+="%s"', entry.ordinal)
    vim.cmd(copy_filename_cmd)
    notify(string.format('Yanked filename "%s" to clipboard', entry.ordinal))
  end,
  ["<leader>yd"] = function()
    local entry = action_state.get_selected_entry()
    local copy_directory_cmd = string.format(':let @+="%s"', entry.cwd)
    vim.cmd(copy_directory_cmd)
    notify(string.format('Yanked working directory "%s" to clipboard', entry.cwd))
  end,
  ["<leader>yp"] = function()
    local entry = action_state.get_selected_entry()
    local copy_path_cmd = string.format(':let @+="%s"', entry.Path.filename)
    vim.cmd(copy_path_cmd)
    notify(string.format('Yanked file path "%s" to clipboard', entry.Path.filename))
  end,
  ["."] = fb_actions.toggle_hidden,
  ["n"] = fb_actions.create,
  ["t"] = fb_actions.change_cwd,
  ["f"] = function()
    local entry = action_state.get_selected_entry()
    local filename = entry.Path.filename
    require("telescope.builtin").live_grep({ search_dirs = { filename }, results_title = filename })
  end,
  ["x"] = fb_actions.remove,
  ["h"] = fb_actions.goto_parent_dir,
  ["H"] = fb_actions.goto_cwd,
  ["l"] = actions.select_default,
}

telescope.setup({
  defaults = {
    initial_mode = "normal",
    file_ignore_patterns = { ".DS_Store" },
    multi_icon = "<>",
    sorting_strategy = "ascending",
    path_display = { truncate = 2 },
    layout_config = {
      width = 0.95,
      height = 0.85,
      prompt_position = "top",
      vertical = {
        width = 0.9,
        height = 0.95,
        preview_height = 0.5,
      },
      flex = {
        horizontal = {
          preview_width = 0.9,
        },
      },
    },

    mappings = {
      i = default_insert_mappings,
      n = default_normal_mappings,
    },
  },

  pickers = {
    buffers = {
      mappings = {
        n = {
          ["<leader>x"] = actions.delete_buffer,
        },
      },
    },
    git_stash = {
      mappings = {
        -- n = {
        --     ["d"] = function()
        --         local entry = action_state.get_selected_entry()
        --         -- local stash_idx = entry.value.find(entry, "%d+")
        --         -- print(vim.inspect(stash_idx))
        --     end,
        -- },
      },
    },
    git_branches = {
      previewer = false,
      mappings = {
        n = {
          ["<leader>x"] = function(prompt_bufnr)
            actions.git_delete_branch(prompt_bufnr)
            require("telescope.builtin").git_branches()
          end,
        },
      },
    },
    find_files = { initial_mode = "insert" },
    registers = {
      mappings = {
        n = {
          ["<leader>e"] = actions.edit_register,
        },
      },
    },
  },

  extensions = {
    file_browser = {
      mappings = {
        n = file_browser_normal_mappings,
      },
    },
    ["ui-select"] = {
      require("telescope.themes").get_cursor({}),
    },
  },
})

require("telescope").load_extension("file_browser")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("possession")
require("telescope").load_extension("notify")
