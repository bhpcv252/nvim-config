return {
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
	{
		'nvim-telescope/telescope-ui-select.nvim'
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "go", "lua", "vim", "javascript", "html", "css", "json", "sql", "typescript" },
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end
	},
	{
		"christoomey/vim-tmux-navigator",
		keys = {
			{ "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	-- {
	--   "ray-x/go.nvim",
	--   dependencies = {  -- optional packages
	--     "ray-x/guihua.lua",
	--     "neovim/nvim-lspconfig",
	--     "nvim-treesitter/nvim-treesitter",
	--   },
	--   config = function()
	--     require("go").setup()
	--   end,
	--   event = {"CmdlineEnter"},
	--   ft = {"go", 'gomod'},
	--   build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
	-- },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		}
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},
	{
		"nvimtools/none-ls.nvim"
	},

	-- For snippets and completion	
	{
		"hrsh7th/nvim-cmp"
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
	},
	{
		"saadparwaiz1/cmp_luasnip"
	},
	{
		"hrsh7th/cmp-nvim-lsp"
	}

}
