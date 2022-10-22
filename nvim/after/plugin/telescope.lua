local telescope = require("telescope")
local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")
local fb_actions = telescope.extensions.file_browser.actions
-- TODO: show current open file highlighted

local custom_actions = {}

function custom_actions.delete_backward_word()
    vim.api.nvim_input("<c-s-w>")
end

local default_mappings = {
    ["c"] = false,
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-h>"] = actions.close,
    ["<C-l>"] = actions.select_default + actions.center,
    ["<C-w>"] = custom_actions.delete_backward_word,
    ["<C-s>"] = actions.select_horizontal,
    ["<M-p>"] = actions_layout.toggle_preview,
}

telescope.setup({
    defaults = {
        file_ignore_patterns = { "node_modules", ".DS_Store" },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        multi_icon = "<>",
        winblend = 0,
        layout_strategy = "horizontal",
        wrap_results = false,
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

        selection_strategy = "reset",
        sorting_strategy = "ascending",
        scroll_strategy = "cycle",
        color_devicons = true,

        mappings = {
            i = default_mappings,
            n = default_mappings,
        },
    },

    pickers = {
        buffers = {
            initial_mode = "normal",
            mappings = {
                i = {
                    ["<C-d>"] = actions.delete_buffer,
                },
                n = {
                    ["<C-d>"] = actions.delete_buffer,
                },
            },
        },
        git_stash = {
            initial_mode = "normal",
        },
        git_branches = {
            previewer = false,
            initial_mode = "normal",
            mappings = {
                n = {
                    ["<C-d>"] = function(opts)
                        actions.git_delete_branch(opts)
                        require("telescope.builtin").git_branches()
                    end,
                    ["<C-m>"] = actions.git_merge_branch,
                },
            },
        }, -- TODO: toggle for local and remote, default to local
    },

    extensions = {
        file_browser = {
            initial_mode = "normal",
            hijack_netrw = true,
            mappings = {
                i = {
                    ["<C-t>"] = fb_actions.change_cwd,
                    ["<C-.>"] = fb_actions.toggle_hidden,
                    ["<C-c>"] = fb_actions.create,
                },
                n = {
                    ["<C-c>"] = fb_actions.create,
                    ["<C-t>"] = fb_actions.change_cwd,
                    ["<C-.>"] = fb_actions.toggle_hidden,
                    ["h"] = fb_actions.goto_parent_dir,
                    ["H"] = fb_actions.goto_cwd,
                    ["l"] = actions.select_default + actions.center,
                    ["F"] = function(one, two)
                        print(vim.inspect(one), vim.inspect(two))
                    end,
                },
            },
        },
        ["ui-select"] = {
            require("telescope.themes").get_cursor({}),
        },
    },
})

require("telescope").load_extension("file_browser")
require("telescope").load_extension("ui-select")
