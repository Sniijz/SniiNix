-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Move lines up/down
map("n", "<A-j>", ":m+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m'>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m'<-2<CR>gv=gv", { desc = "Move selection up" })
map("n", "<A-Down>", ":m+1<CR>==", { desc = "Move line down" })
map("n", "<A-Up>", ":m-2<CR>==", { desc = "Move line up" })
map("v", "<A-Down>", ":m'>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-Up>", ":m'<-2<CR>gv=gv", { desc = "Move selection up" })

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

-- Keymaps for diagnostics
map("n", "gl", vim.diagnostic.open_float, { desc = "Show Line Diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

-- Inlay Hints Toggle
map("n", "<leader>gi", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- Noh disable search highlight
map("n", "<F3>", ":noh<CR>", { desc = "Clear Highlight" })


