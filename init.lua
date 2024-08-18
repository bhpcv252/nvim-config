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

o.foldcolumn = '1'
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true

opt.mouse = "a"
opt.wrap = false

g.mapleader = " "
g.maplocalleader = " "


vim.api.nvim_set_keymap('n', 'j', 'jzz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'k', 'kzz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Down>', 'jzz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Up>', 'kzz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'G', 'Gzz', { noremap = true, silent = true })


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
vim.keymap.set('n', '<leader>oo', ':Neotree filesystem toggle left<CR>')


-- Lualine
require('lualine').setup({
	option = {
		theme = "gruvbox"
	}
})


-- Mason LSP (and stuff) package manager
require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "lua_ls", "tsserver", "gopls", "eslint" }
}

local capabilities1 = require('cmp_nvim_lsp').default_capabilities()
local capabilities2 = vim.lsp.protocol.make_client_capabilities()

capabilities2.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true
}

-- Merge capabilities1 and capabilities2
local capabilities = vim.tbl_deep_extend('force', capabilities1, capabilities2)

local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup({
	capabilities = capabilities
}) -- Lua
lspconfig.tsserver.setup({
	capabilities = capabilities
}) -- Typescript/Javascript
lspconfig.gopls.setup({
	capabilities = capabilities
}) -- Go
lspconfig.eslint.setup({
	capabilities = capabilities
}) -- Eslint


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

-- Nvim snippets and completion
local cmp = require('cmp')

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' }, -- For luasnip users.
	}, {
		{ name = 'buffer' },
	})
})


-- Gitsigns
require('gitsigns').setup({
	on_attach = function(bufnr)
		local gitsigns = require('gitsigns')

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		map('n', '<leader>gh', gitsigns.preview_hunk)
		map('n', '<leader>gb', gitsigns.toggle_current_line_blame)
	end
})


-- Indent blank line
require("ibl").setup()


-- Nvim UFO - for folding blocks
local foldHandler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

require('ufo').setup({
	    fold_virt_text_handler = foldHandler
})
