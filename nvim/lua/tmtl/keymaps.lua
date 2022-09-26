local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true, noremap = true, })
end

vim.g.mapleader = " "

map({ "n", "v" }, "H", "^")
map({ "n", "v" }, "L", "$")

map("i", "kj", "<ESC>")
-- map("i", "<C-j>", "<ESC>") -- TODO: testsetnvim cmp suggestions */
-- map("i", "<C-j>", "<ESC>")

map("v", "*", 'y/<C-R>"<CR>') -- search for current selection
map("v", "#", 'y?<C-R>"<CR>') -- search for current selection
map("v", "p", "pgvy")
map("v", "P", "Pgvy")

map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "Y", "yy")

map("n", "<leader>sp", ":PackerSync<cr>") -- source / synce plugins
-- map("n", "<F5>", reload_nvim) -- TODO: update after folder change / runtime structure
map("n", "<leader>i", "i <ESC>i")

-- Tabs (buffers)
map("n", "<leader>ta", "<cmd>:%bd<cr>")
map("n", "<leader>to", "<cmd>%bd|e#|bd#<cr>")
map("n", "<leader>tj", "<cmd>:bNext<cr>")
map("n", "<leader>tk", "<cmd>:bprevious<cr>")

-- Diagnostics
map("n", "<leader>dj", "<cmd>lua vim.diagnostic.goto_next()<cr>zz")
map("n", "<leader>dk", "<cmd>lua vim.diagnostic.goto_prev()<cr>zz")
map("n", "<leader>da", "<cmd>CodeActionMenu<cr>")
map("n", "<leader>dr", "<cmd>lua vim.lsp.buf.rename()<cr>")
map("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>")

-- Fuzzy finder (files)
map("n", "<C-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<leader>/", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>") -- find in current buffer
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').live_grep()<cr>") -- find in files
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>") -- find in files
map("n", "<leader>fc", "<cmd>Telescope find_files cwd=~/.dotfiles<cr>") -- find in config
map("n", "<leader>fw", "<cmd>lua require('telescope.builtin').find_files({ cwd = vim.fn.expand('%:p:h')})<cr>") -- find in cwd
map("n", "<leader>fx", ":Telescope find_files cwd=~/.config") -- x for explore??

-- Fuzzy finder (browser)
map("n", "<leader>bp", "<cmd>lua require('telescope').extensions.file_browser.file_browser({ grouped = true })<cr>") -- browser project
map("n", "<leader>bw",
    "<cmd>lua require('telescope').extensions.file_browser.file_browser({ grouped = true,  cwd = vim.fn.expand('%:p:h') })<cr>") -- browser cwd
map("n", "<leader>bc",
    "<cmd>lua require('telescope').extensions.file_browser.file_browser({ grouped = true,  cwd = '~/.dotfiles' })<cr>")
map("n", "<leader>bx", "<cmd>Telescope file_browser grouped=true cwd=~/code<cr>") -- x for explore??

-- Git
map("n", "<leader>gs", "<cmd>Neogit<cr>")
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>")
map("n", "<leader>gh", "<cmd>lua require('telescope.builtin').git_commits()<cr>")

map("n", "<leader>hj", "<cmd>Gitsigns next_hunk<cr>zz")
map("n", "<leader>hk", "<cmd>Gitsigns prev_hunk<cr>zz")
map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>")
map({ "n", "v" }, "<leader>hs", "<cmd>Gitsigns stage_hunk<cr><ESC><cmd>DiffviewRefresh<cr>")
map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr><cmd>DiffviewRefresh<cr>")
map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr><cmd>DiffviewRefresh<cr>")

map("n", "<leader>fs", "<cmd>Gitsigns stage_buffer<cr><cmd>DiffviewRefresh<cr>")
map("n", "<leader>fr", "<cmd>Gitsigns reset_buffer<cr><cmd>DiffviewRefresh<cr>")

-- Quick fix list
map("n", "<leader>ql", "<cmd>copen<cr>")
map("n", "<leader>qj", "<cmd>cnext<cr>")
map("n", "<leader>qk", "<cmd>cprevious<cr>")

-- Quick edit files
map("n", "<leader>ea", "<cmd>lua require('harpoon.mark').add_file()<cr>")
map("n", "<leader>el", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>")
map("n", "<A-n>", "<cmd>lua require('harpoon.ui').nav_next()<cr>")
map("n", "<A-p>", "<cmd>lua require('harpoon.ui').nav_prev()<cr>")
map("n", "<A-h>", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>")
map("n", "<A-j>", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>")
map("n", "<A-k>", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>")
map("n", "<A-l>", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>")

vim.cmd [[nmap <Leader>r <Plug>ReplaceWithRegisterOperator]]
vim.cmd [[nmap <Leader>(( <Plug>ReplaceWithRegisterLine]] -- TODO: just unmap
vim.g.code_action_menu_show_details = false -- TODO: move
