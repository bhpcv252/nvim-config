local g = vim.g
local o = vim.o
local opt = vim.opt


o.number = true
o.relativenumber = true
o.autoindent = true
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4

o.expandtab = true

o.termguicolors = true

o.clipboard = "unnamedplus"

o.ignorecase = true
o.smartcase = true

o.history = 50

o.splitright = true
o.splitbelow = true

o.foldcolumn = "0"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true

opt.mouse = "a"
opt.wrap = false

o.list = true
opt.listchars = { tab = "→ " }
opt.guicursor =
"n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,n-v-c-sm:block-blinkwait700-blinkoff400-blinkon100-Cursor/lCursor"

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
    checker = { enabled = false },
})


-- Catppuccin Colorscheme
require("catppuccin").setup({
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = {    -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
    term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false,            -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15,          -- percentage of the shade to apply to the inactive window
    },
    no_italic = false,              -- Force no italic
    no_bold = false,                -- Force no bold
    no_underline = false,           -- Force no underline
    styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" },    -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {
        mocha = {
            base = "#1A1A19",
            mantle = "#212121",
            blue = "#94e2d5",
            green = "#729762",
            flamingo = "#8967B3",
            sky = "#578FCA",
            yellow = "#F6C794",
            surface0 = "#373A40",
            surface1 = "#BF3131",
        }
    },
    custom_highlights = {},
    highlight_overrides = {
        mocha = {
            Visual = { bg = "#BF3131", fg = "#ffffff" }, -- Custom visual mode highlighting
        }
    },
    default_integrations = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        neotree = true,
        telescope = {
            enabled = true,
        },
        indent_blankline = {
            enabled = true,
            scope_color = "surface1", -- catppuccin color (eg. `lavender`) Default: text
            colored_indent_levels = false,
        },

    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"

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
        theme = "catppuccin"
    }
})


-- Mason LSP (and stuff) package manager
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "gopls", "pyright", "jsonls", "biome", "tailwindcss", "marksman", "glsl_analyzer", "wgsl_analyzer", "cssls", "sqls", "vimls", "yamlls", "zls", "bashls", "clangd", "graphql", "typos_lsp", "dprint", "neocmake" }
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
local lsputils = require('lspconfig/util')

lspconfig.lua_ls.setup({
    capabilities = capabilities
}) -- Lua

lspconfig.gopls.setup({
    capabilities = capabilities,
    settings = {
        gopls = {
            completeUnimported = true,
            gofumpt = true,
            buildFlags = { "-tags=integration,e2e,outbox" },
        }
    }
}) -- Go

lspconfig.pyright.setup({
    capabilities = capabilities
}) -- Python

lspconfig.jsonls.setup({
    capabilities = capabilities
}) -- JSON

lspconfig.biome.setup({
    capabilities = capabilities,
    autostart = true,
    root_dir = function(fname)
        return require('lspconfig').util.find_git_ancestor(fname) or vim.fn.getcwd()
    end,
}) -- Typescript/Javascript/React/Vue/etc... Mostly Frontend

lspconfig.tailwindcss.setup({
    capabilities = capabilities
}) -- Tailwind CSS

lspconfig.marksman.setup({
    capabilities = capabilities
}) -- Markdown/MDX

lspconfig.glsl_analyzer.setup({
    capabilities = capabilities
}) -- GLSL/Vert/Frag/etc..

lspconfig.wgsl_analyzer.setup({
    capabilities = capabilities
}) -- WGSL

lspconfig.cssls.setup({
    capabilities = capabilities
}) -- CSS/SCSS/LESS

lspconfig.sqls.setup({
    capabilities = capabilities
}) -- SQL

lspconfig.vimls.setup({
    capabilities = capabilities
}) -- VimScript

lspconfig.yamlls.setup({
    capabilities = capabilities
}) -- Yaml

lspconfig.zls.setup({
    capabilities = capabilities
}) -- ZIG

lspconfig.bashls.setup({
    capabilities = capabilities
}) -- BASH/SH/ZSH

lspconfig.clangd.setup({
    capabilities = capabilities,
    filetypes = {
        "c",
        "cpp",
        "objc",
        "objcpp",
        "cuda",
    },
}) -- C/C++

lspconfig.protols.setup({
    capabilities = capabilities,
})

lspconfig.graphql.setup({
    capabilities = capabilities
}) -- GraphQL

lspconfig.typos_lsp.setup({
    capabilities = capabilities,
    init_options = {
        diagnosticSeverity = "Hint"
    }
}) -- Typo Checking

lspconfig.dprint.setup({
    capabilities = capabilities
}) -- Code Formatting for several languages

lspconfig.neocmake.setup({
    capabilities = capabilities
}) -- Code Formatting for several languages

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
    end,
})


-- Null/None LS
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.golines,
        null_ls.builtins.formatting.goimports_reviser,
        null_ls.builtins.formatting.prettier,
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
                group = augroup,
                buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        buffer = bufnr
                    })
                end
            })
        end
    end
})


vim.keymap.set('n', 'gf', function()
    vim.lsp.buf.format({ async = false })
end, {})

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
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
end

require('ufo').setup({
    fold_virt_text_handler = foldHandler
})


-- Colorizer
require('colorizer').setup({
    'css',
    'javascript',
    'html',
}, {
    css = true,
})


-- Terminal mapping
vim.api.nvim_set_keymap('n', '<leader>tt', ':term<CR>', { noremap = true, silent = true })
vim.cmd([[
  autocmd TermOpen * startinsert
]])
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })


-- Aerial setup
require("aerial").setup({
    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,
})

vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")


-- Diffview
local actions = require("diffview.actions")

require("diffview").setup({
    git_cmd = { "git" },          -- The git executable followed by default args.
    hg_cmd = { "hg" },            -- The hg executable followed by default args.
    use_icons = true,             -- Requires nvim-web-devicons
    keymaps = {
        disable_defaults = false, -- Disable the default keymaps
        view = {
            -- The `view` bindings are active in the diff buffers, only when the current
            -- tabpage is a Diffview.
            { "n", "<tab>",      actions.select_next_entry,             { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>",    actions.select_prev_entry,             { desc = "Open the diff for the previous file" } },
            { "n", "[F",         actions.select_first_entry,            { desc = "Open the diff for the first file" } },
            { "n", "]F",         actions.select_last_entry,             { desc = "Open the diff for the last file" } },
            { "n", "gf",         actions.goto_file_edit,                { desc = "Open the file in the previous tabpage" } },
            { "n", "<C-w><C-f>", actions.goto_file_split,               { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf",    actions.goto_file_tab,                 { desc = "Open the file in a new tabpage" } },
            { "n", "<leader>e",  actions.focus_files,                   { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b",  actions.toggle_files,                  { desc = "Toggle the file panel." } },
            { "n", "g<C-x>",     actions.cycle_layout,                  { desc = "Cycle through available layouts." } },
            { "n", "[x",         actions.prev_conflict,                 { desc = "In the merge-tool: jump to the previous conflict" } },
            { "n", "]x",         actions.next_conflict,                 { desc = "In the merge-tool: jump to the next conflict" } },
            { "n", "<leader>co", actions.conflict_choose("ours"),       { desc = "Choose the OURS version of a conflict" } },
            { "n", "<leader>ct", actions.conflict_choose("theirs"),     { desc = "Choose the THEIRS version of a conflict" } },
            { "n", "<leader>cb", actions.conflict_choose("base"),       { desc = "Choose the BASE version of a conflict" } },
            { "n", "<leader>ca", actions.conflict_choose("all"),        { desc = "Choose all the versions of a conflict" } },
            { "n", "dx",         actions.conflict_choose("none"),       { desc = "Delete the conflict region" } },
            { "n", "<leader>cO", actions.conflict_choose_all("ours"),   { desc = "Choose the OURS version of a conflict for the whole file" } },
            { "n", "<leader>cT", actions.conflict_choose_all("theirs"), { desc = "Choose the THEIRS version of a conflict for the whole file" } },
            { "n", "<leader>cB", actions.conflict_choose_all("base"),   { desc = "Choose the BASE version of a conflict for the whole file" } },
            { "n", "<leader>cA", actions.conflict_choose_all("all"),    { desc = "Choose all the versions of a conflict for the whole file" } },
            { "n", "dX",         actions.conflict_choose_all("none"),   { desc = "Delete the conflict region for the whole file" } },
        },
        diff1 = {
            -- Mappings in single window diff layouts
            { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
        },
        diff2 = {
            -- Mappings in 2-way diff layouts
            { "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
        },
        diff3 = {
            -- Mappings in 3-way diff layouts
            { { "n", "x" }, "2do", actions.diffget("ours"),           { desc = "Obtain the diff hunk from the OURS version of the file" } },
            { { "n", "x" }, "3do", actions.diffget("theirs"),         { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
            { "n",          "g?",  actions.help({ "view", "diff3" }), { desc = "Open the help panel" } },
        },
        diff4 = {
            -- Mappings in 4-way diff layouts
            { { "n", "x" }, "1do", actions.diffget("base"),           { desc = "Obtain the diff hunk from the BASE version of the file" } },
            { { "n", "x" }, "2do", actions.diffget("ours"),           { desc = "Obtain the diff hunk from the OURS version of the file" } },
            { { "n", "x" }, "3do", actions.diffget("theirs"),         { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
            { "n",          "g?",  actions.help({ "view", "diff4" }), { desc = "Open the help panel" } },
        },
        file_panel = {
            { "n", "j",             actions.next_entry,                    { desc = "Bring the cursor to the next file entry" } },
            { "n", "<down>",        actions.next_entry,                    { desc = "Bring the cursor to the next file entry" } },
            { "n", "k",             actions.prev_entry,                    { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<up>",          actions.prev_entry,                    { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<cr>",          actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
            { "n", "o",             actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
            { "n", "l",             actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
            { "n", "<2-LeftMouse>", actions.select_entry,                  { desc = "Open the diff for the selected entry" } },
            { "n", "-",             actions.toggle_stage_entry,            { desc = "Stage / unstage the selected entry" } },
            { "n", "s",             actions.toggle_stage_entry,            { desc = "Stage / unstage the selected entry" } },
            { "n", "S",             actions.stage_all,                     { desc = "Stage all entries" } },
            { "n", "U",             actions.unstage_all,                   { desc = "Unstage all entries" } },
            { "n", "X",             actions.restore_entry,                 { desc = "Restore entry to the state on the left side" } },
            { "n", "L",             actions.open_commit_log,               { desc = "Open the commit log panel" } },
            { "n", "zo",            actions.open_fold,                     { desc = "Expand fold" } },
            { "n", "h",             actions.close_fold,                    { desc = "Collapse fold" } },
            { "n", "zc",            actions.close_fold,                    { desc = "Collapse fold" } },
            { "n", "za",            actions.toggle_fold,                   { desc = "Toggle fold" } },
            { "n", "zR",            actions.open_all_folds,                { desc = "Expand all folds" } },
            { "n", "zM",            actions.close_all_folds,               { desc = "Collapse all folds" } },
            { "n", "<c-b>",         actions.scroll_view(-0.25),            { desc = "Scroll the view up" } },
            { "n", "<c-f>",         actions.scroll_view(0.25),             { desc = "Scroll the view down" } },
            { "n", "<tab>",         actions.select_next_entry,             { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>",       actions.select_prev_entry,             { desc = "Open the diff for the previous file" } },
            { "n", "[F",            actions.select_first_entry,            { desc = "Open the diff for the first file" } },
            { "n", "]F",            actions.select_last_entry,             { desc = "Open the diff for the last file" } },
            { "n", "gf",            actions.goto_file_edit,                { desc = "Open the file in the previous tabpage" } },
            { "n", "<C-w><C-f>",    actions.goto_file_split,               { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf",       actions.goto_file_tab,                 { desc = "Open the file in a new tabpage" } },
            { "n", "i",             actions.listing_style,                 { desc = "Toggle between 'list' and 'tree' views" } },
            { "n", "f",             actions.toggle_flatten_dirs,           { desc = "Flatten empty subdirectories in tree listing style" } },
            { "n", "R",             actions.refresh_files,                 { desc = "Update stats and entries in the file list" } },
            { "n", "<leader>e",     actions.focus_files,                   { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b",     actions.toggle_files,                  { desc = "Toggle the file panel" } },
            { "n", "g<C-x>",        actions.cycle_layout,                  { desc = "Cycle available layouts" } },
            { "n", "[x",            actions.prev_conflict,                 { desc = "Go to the previous conflict" } },
            { "n", "]x",            actions.next_conflict,                 { desc = "Go to the next conflict" } },
            { "n", "g?",            actions.help("file_panel"),            { desc = "Open the help panel" } },
            { "n", "<leader>cO",    actions.conflict_choose_all("ours"),   { desc = "Choose the OURS version of a conflict for the whole file" } },
            { "n", "<leader>cT",    actions.conflict_choose_all("theirs"), { desc = "Choose the THEIRS version of a conflict for the whole file" } },
            { "n", "<leader>cB",    actions.conflict_choose_all("base"),   { desc = "Choose the BASE version of a conflict for the whole file" } },
            { "n", "<leader>cA",    actions.conflict_choose_all("all"),    { desc = "Choose all the versions of a conflict for the whole file" } },
            { "n", "dX",            actions.conflict_choose_all("none"),   { desc = "Delete the conflict region for the whole file" } },
        },
        file_history_panel = {
            { "n", "g!",            actions.options,                    { desc = "Open the option panel" } },
            { "n", "<C-A-d>",       actions.open_in_diffview,           { desc = "Open the entry under the cursor in a diffview" } },
            { "n", "y",             actions.copy_hash,                  { desc = "Copy the commit hash of the entry under the cursor" } },
            { "n", "L",             actions.open_commit_log,            { desc = "Show commit details" } },
            { "n", "X",             actions.restore_entry,              { desc = "Restore file to the state from the selected entry" } },
            { "n", "zo",            actions.open_fold,                  { desc = "Expand fold" } },
            { "n", "zc",            actions.close_fold,                 { desc = "Collapse fold" } },
            { "n", "h",             actions.close_fold,                 { desc = "Collapse fold" } },
            { "n", "za",            actions.toggle_fold,                { desc = "Toggle fold" } },
            { "n", "zR",            actions.open_all_folds,             { desc = "Expand all folds" } },
            { "n", "zM",            actions.close_all_folds,            { desc = "Collapse all folds" } },
            { "n", "j",             actions.next_entry,                 { desc = "Bring the cursor to the next file entry" } },
            { "n", "<down>",        actions.next_entry,                 { desc = "Bring the cursor to the next file entry" } },
            { "n", "k",             actions.prev_entry,                 { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<up>",          actions.prev_entry,                 { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<cr>",          actions.select_entry,               { desc = "Open the diff for the selected entry" } },
            { "n", "o",             actions.select_entry,               { desc = "Open the diff for the selected entry" } },
            { "n", "l",             actions.select_entry,               { desc = "Open the diff for the selected entry" } },
            { "n", "<2-LeftMouse>", actions.select_entry,               { desc = "Open the diff for the selected entry" } },
            { "n", "<c-b>",         actions.scroll_view(-0.25),         { desc = "Scroll the view up" } },
            { "n", "<c-f>",         actions.scroll_view(0.25),          { desc = "Scroll the view down" } },
            { "n", "<tab>",         actions.select_next_entry,          { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>",       actions.select_prev_entry,          { desc = "Open the diff for the previous file" } },
            { "n", "[F",            actions.select_first_entry,         { desc = "Open the diff for the first file" } },
            { "n", "]F",            actions.select_last_entry,          { desc = "Open the diff for the last file" } },
            { "n", "gf",            actions.goto_file_edit,             { desc = "Open the file in the previous tabpage" } },
            { "n", "<C-w><C-f>",    actions.goto_file_split,            { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf",       actions.goto_file_tab,              { desc = "Open the file in a new tabpage" } },
            { "n", "<leader>e",     actions.focus_files,                { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b",     actions.toggle_files,               { desc = "Toggle the file panel" } },
            { "n", "g<C-x>",        actions.cycle_layout,               { desc = "Cycle available layouts" } },
            { "n", "g?",            actions.help("file_history_panel"), { desc = "Open the help panel" } },
        },
        option_panel = {
            { "n", "<tab>", actions.select_entry,         { desc = "Change the current option" } },
            { "n", "q",     actions.close,                { desc = "Close the panel" } },
            { "n", "g?",    actions.help("option_panel"), { desc = "Open the help panel" } },
        },
        help_panel = {
            { "n", "q",     actions.close, { desc = "Close help menu" } },
            { "n", "<esc>", actions.close, { desc = "Close help menu" } },
        },
    },
})
