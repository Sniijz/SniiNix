-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Search and Replace (Grug-far)
map("n", "<leader>sr", function()
	require("grug-far").open()
end, { desc = "Search and Replace (Grug-far)" })
map("n", "<leader>sw", function()
	require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search and Replace Word" })
map("v", "<leader>sr", function()
	require("grug-far").with_visual_selection({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search and Replace Selection" })

-- LazyGit
map("n", "<leader>lg", function()
	require("lazy.util").float_term({ "lazygit" }, { cwd = require("lazyvim.util").root.get() })
end, { desc = "LazyGit (Root Dir)" })

-- Toggle Numbering
map("n", "<leader>no", function()
	local nu = vim.opt.number:get()
	local rnu = vim.opt.relativenumber:get()
	if nu and rnu then
		vim.cmd("set nonumber norelativenumber")
	elseif nu and not rnu then
		vim.cmd("set nonumber norelativenumber")
	else
		vim.cmd("set number relativenumber")
	end
end, { desc = "Cycle Numbering" })

-- Barbar Keymaps (Buffer navigation)
map("n", "<leader>bp", "<Cmd>BufferPin<CR>", { desc = "Pin Buffer" })
map("n", "<leader>bc", "<Cmd>BufferCloseBuffersLeft<CR>", { desc = "Close Buffers Left" })
map("n", "<leader>bv", "<Cmd>BufferCloseBuffersRight<CR>", { desc = "Close Buffers Right" })
map("n", "<leader>bn", "<Cmd>BufferNext<CR>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<Cmd>BufferPrevious<CR>", { desc = "Prev Buffer" })
-- Goto buffers
map("n", "<leader>&", "<Cmd>BufferGoto 1<CR>", { desc = "Buffer 1" })
map("n", "<leader>é", "<Cmd>BufferGoto 2<CR>", { desc = "Buffer 2" })
map("n", '<leader>"', "<Cmd>BufferGoto 3<CR>", { desc = "Buffer 3" })
map("n", "<leader>'", "<Cmd>BufferGoto 4<CR>", { desc = "Buffer 4" })
map("n", "<leader>(", "<Cmd>BufferGoto 5<CR>", { desc = "Buffer 5" })
map("n", "<leader>-", "<Cmd>BufferGoto 6<CR>", { desc = "Buffer 6" })
map("n", "<leader>è", "<Cmd>BufferGoto 7<CR>", { desc = "Buffer 7" })
map("n", "<leader>_", "<Cmd>BufferGoto 8<CR>", { desc = "Buffer 8" })
map("n", "<leader>ç", "<Cmd>BufferGoto 9<CR>", { desc = "Buffer 9" })

-- Git
map("n", "<leader>gb", function()
	require("mini.git").show_at_cursor()
end, { desc = "Git Blame" })

-- Inlay Hints Toggle
map("n", "<leader>gi", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- Noh
map("n", "<F3>", ":noh<CR>", { desc = "Clear Highlight" })
