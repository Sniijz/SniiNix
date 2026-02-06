-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Markdown Headings Highlight
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = "#D4D4D4", bold = true, bg = "NONE" })
    vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = "#C586C0", bold = true, bg = "NONE" })
    vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = "#CE9178", bold = true, bg = "NONE" })
    vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = "#569CD6", bold = true, bg = "NONE" })
    vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = "#DCDCAA", bold = true, bg = "NONE" })
    vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = "#B5CEA8", bold = true, bg = "NONE" })
  end,
})

-- Pico8 extension
vim.filetype.add({
  extension = {
    p8 = "pico8",
  },
})

-- Jinja2 extensions
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.jinja", "*.jinja2", "*.j2" },
  callback = function()
    vim.bo.filetype = "jinja"
  end,
})

-- Diagnostics Styling
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
