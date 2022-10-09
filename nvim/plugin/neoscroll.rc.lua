require("neoscroll").setup({
    mappings = { "<C-u>", "<C-d>" },
    hide_cursor = true, -- Hide cursor while scrolling
    stop_eof = true, -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
})

local t = {}
t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "150" } }
t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "150" } }
require("neoscroll.config").set_mappings(t)
