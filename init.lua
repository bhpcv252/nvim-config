local g = vim.g
local o = vim.o
local opt = vim.opt
local cmd = vim.cmd


o.number = true
o.relativenumber = true
o.autoindent = true
o.tabstop = 4
o.shiftwidth = 4

o.termguicolors = true

o.clipboard = "unnamedplus"

o.ignorecase = true
o.smartcase = true

o.history = 50

o.splitright = true
o.splitbelow = true

opt.mouse = "a"

g.mapleader = " "
g.maplocalleader = " "



-- Lazy Nvim package manager

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)


-- Setup lazy.nvim
require("lazy").setup({
	spec = require("plugins"),
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})


-- Catppuccin Colorscheme
require("catppuccin").setup()
cmd.colorscheme "catppuccin"


-- Telescope Fuzzy Finder

require("telescope").setup {
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown {
				-- even more opts
			}

		}
	}
}


require("telescope").load_extension("ui-select")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


-- Go nvim
-- local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.go",
--   callback = function()
--    require('go.format').goimports()
--   end,
--   group = format_sync_grp,
-- })
--

-- Neo Tree
require("neo-tree").setup({
	filesystem = {
		filtered_items = {
			visible = true,
			show_hidden_count = true,
			hide_dotfiles = false,
			hide_gitignored = false,
			never_show = {
				".git",
				".DS_Store",
				"thumbs.db"
			},
		},
	}
})
vim.keymap.set('n', '<leader>oo', ':Neotree filesystem reveal left<CR>')


-- Lualine
require('lualine').setup({
	option = {
		theme = "gruvbox"
	}
})


-- Mason LSP (and stuff) package manager
require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "lua_ls", "tsserver", "gopls", "eslint", "prettier"}
}
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup({})   -- Lua
lspconfig.tsserver.setup({}) -- Typescript/Javascript
lspconfig.gopls.setup({})    -- Go
lspconfig.eslint.setup({}) -- Eslint


vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
		vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
	end,
})


-- Null/None LS
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
	},
})


vim.keymap.set('n', 'gf', vim.lsp.buf.format, {})
