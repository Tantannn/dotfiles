
--[[

=====================================================================
==================== read this before continuing ====================
=====================================================================

kickstart.nvim is *not* a distribution.

kickstart.nvim is a template for your own configuration.
  the goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  once you've done that, you should start exploring, configuring and tinkering to
  explore neovim!

  if you don't know anything about lua, i recommend taking some time to read through
  a guide. one possible example:
  - https://learnxinyminutes.com/docs/lua/

  and then you can explore or search through `:help lua-guide`


kickstart guide:

i have left several `:help x` comments throughout the init.lua
you should run that command and read that help section for more information.

in addition, i have some `note:` items throughout the file.
these are for you, the reader to help understand what is happening. feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

i hope you enjoy your neovim journey,
- tj

p.s. you can delete this when you're done too. it's your config now :)
--]]
-- set <space> as the leader key
-- see `:help mapleader`
--  note: must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwplugin = 1
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- note: here is where you install your plugins.
--  you can configure plugins using the `config` key.
--
--  you can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- note: first, some plugins that don't require any configuration

  -- git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
      prefer_startup_root = false,

  -- detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- note: this is where your plugins related to lsp can be installed.
  --  the configuration is done below. search for lspconfig to find it below.
  {
    -- lsp configuration & plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- automatically install lsps to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- useful status updates for lsp
      -- note: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- snippet engine & its associated nvim-cmp source
      'l3mon4d3/luasnip',
      'saadparwaiz1/cmp_luasnip',

      -- adds lsp completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      -- adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- see `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '[c', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'go to previous hunk' })
        vim.keymap.set('n', ']c', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'go to next hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[p]review [h]unk' })
      end,
    },
  },

  {
    -- theme inspired by atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  {
    -- set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- see `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- enable `lukas-reineke/indent-blankline.nvim`
    -- see `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numtostr/comment.nvim', opts = {} },

  -- fuzzy finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- fuzzy finder algorithm which requires local dependencies to be built.
  -- only load if `make` is available. make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- note: if you are having trouble with this installation,
    --       refer to the readme for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':tsupdate',
  },

  -- note: next step on your neovim journey: add/configure additional "plugins" for kickstart
  --       these are some example plugins that i've included in the kickstart repository.
  --       uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- note: the import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    you can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    for additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
    {'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- optional: for git status
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.

  -- set the filetypes which barbar will offset itself for
  sidebar_filetypes = {
    -- use the default values: {event = 'bufwinleave', text = nil}
    -- nvimtree = true,
    -- or, specify the text used for the offset:
     undotree = {text = 'undotree'},
    -- or, specify the event which the sidebar executes when leaving:
    -- ['neo-tree'] = {event = 'bufwipeout'},
    -- or, specify both
    outline = {event = 'bufwinleave', text = 'symbols-outline'},
  },
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
  -- emmet
  'mattn/emmet-vim',
  {
    "pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup {
	-- your config goes here
	-- or just leave it empty :)
	enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
	execution_message = {
	  message = function() -- message to print on save
	    return ("autosave: saved at " .. vim.fn.strftime("%h:%m:%s"))
	  end,
	  dim = 0.18, -- dim the color of `message`
	  cleaning_interval = 1250, -- (milliseconds) automatically clean msgarea after displaying `message`. see :h msgarea
	},
	trigger_events = {"insertleave", "textchanged"}, -- vim events that trigger auto-save. see :h events
	-- function that determines whether to save the current buffer or not
	-- return true: if buffer is ok to be saved
	-- return false: if it's not ok to be saved
	condition = function(buf)
	  local fn = vim.fn
	  local utils = require("auto-save.utils.data")

	  if
	    fn.getbufvar(buf, "&modifiable") == 1 and
	    utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
	    return true -- met condition(s), can save
	  end
	  return false -- can't save
	end,
	write_all_buffers = true, -- write all buffers when the current one meets `condition`
	debounce_delay = 135, -- saves the file at most every `debounce_delay` milliseconds
	callbacks = { -- functions to be executed at different intervals
	  enabling = nil, -- ran when enabling auto-save
	  disabling = nil, -- ran when disabling auto-save
	  before_asserting_save = nil, -- ran before checking `condition`
	  before_saving = nil, -- ran before doing the actual save
	  after_saving = nil -- ran after doing the actual save
	}

      }
    end,
  },
  -- sidebar
  { "nvim-tree/nvim-web-devicons" },
  {"nvim-tree/nvim-tree.lua"},
  -- undo tree
  {'mbbill/undotree'},
  -- auto close tag
  {'windwp/nvim-ts-autotag'},
  {'windwp/nvim-autopairs'},
  -- line connect 
  {"lukas-reineke/indent-blankline.nvim" },
  --trouble shooting
  {
 "folke/trouble.nvim",
 opts = {
    position = "bottom", -- position of the list can be: bottom, top, left, right
    height = 10, -- height of the trouble list when position is top or bottom
    width = 50, -- width of the list when position is left or right
    icons = true, -- use devicons for filenames
    mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    severity = nil, -- nil (all) or vim.diagnostic.severity.error | warn | info | hint
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    group = true, -- group results by file
    padding = true, -- add an extra new line on top of the list
    action_keys = { -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        close = "q", -- close the list
        cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r", -- manually refresh
        jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
        open_split = { "<c-x>" }, -- open buffer in new split
        open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
        open_tab = { "<c-t>" }, -- open buffer in new tab
        jump_close = {"o"}, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        switch_severity = "s", -- switch "diagnostics" severity filter level to hint / info / warn / error
        toggle_preview = "p", -- toggle auto_preview
        hover = "k", -- opens a small popup with the full multiline message
        preview = "p", -- preview the diagnostic location
        close_folds = {"zm", "zm"}, -- close all folds
        open_folds = {"zr", "zr"}, -- open all folds
        toggle_fold = {"za", "za"}, -- toggle fold of current file
        previous = "k", -- previous item
        next = "j" -- next item
    },
    indent_lines = true, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
    use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
},
},
  --auto import
  {'neovim/nvim-lspconfig'},
  {'jose-elias-alvarez/null-ls.nvim'},
  {'muniftanjim/eslint.nvim'},
  --search
  -- {'junegunn/fzf.vim'}
  --tailwindcss
  {'sublimelsp/lsp-tailwindcss'},
  --vim surround 
  {'tpope/vim-surround'},

  { import = 'custom.plugins' },

}, {})

-- [[ setting options ]]
-- see `:help vim.o`
-- note: you can change these options as you wish!

-- set highlight on search
vim.o.hlsearch = true

-- make line numbers default
vim.wo.number = true

-- enable mouse mode
vim.o.mouse = 'a'

-- sync clipboard between os and neovim.
--  remove this option if you want your os clipboard to remain independent.
--  see `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- enable break indent
vim.o.breakindent = true

-- save undo history
vim.o.undofile = true

-- case insensitive searching unless /c or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- configure signcolumn on by default
--vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("home") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
-- decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- note: you should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ basic keymaps ]]

-- keymaps for better default experience
-- see `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<space>', '<nop>', { silent = true })

-- remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ highlight on yank ]]
-- see `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('yankhighlight', { clear = true })
vim.api.nvim_create_autocmd('textyankpost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ configure telescope ]]
-- see `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<c-u>'] = false,
        ['<c-d>'] = false,
      },
    },
  },
}

-- enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- see `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- you can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'search [g]it [f]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[s]earch [f]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[s]earch [h]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[s]earch current [w]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[s]earch by [g]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[s]earch [d]iagnostics' })
vim.keymap.set('n', '<leader>sa', require('telescope.builtin').live_grep, { desc = '[s]earch in [a]ll files' })

-- [[ configure treesitter ]]
-- see `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim',  'html'},

  -- autoinstall languages that are not installed. defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<m-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- you can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']m'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[m'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>a'] = '@parameter.inner',
      },
    },
  },
  autotag = {
    enable = true,
  }
}

-- diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'open diagnostics list' })

-- [[ configure lsp ]]
--  this function gets run when an lsp connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- note: remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- in this case, we create a function that lets us more easily define mappings specific
  -- for lsp related items. it sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'lsp: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')

  nmap('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
  nmap('gi', vim.lsp.buf.implementation, '[g]oto [i]mplementation')
  nmap('<leader>d', vim.lsp.buf.type_definition, 'type [d]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')

  -- see `:help k` for why this keymap
  nmap('k', vim.lsp.buf.hover, 'hover documentation')
  nmap('<c-k>', vim.lsp.buf.signature_help, 'signature documentation')

  -- lesser used lsp functionality
  nmap('gd', vim.lsp.buf.declaration, '[g]oto [d]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[w]orkspace [a]dd folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [r]emove folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[w]orkspace [l]ist folders')

  -- create a command `:format` local to the lsp buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'format current buffer with lsp' })
end

-- enable the following language servers
--  feel free to add/remove any lsps that you want here. they will automatically be installed.
--
--  add any additional override configuration in the following tables. they will be passed to
--  the `settings` field of the server config. you must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  tsserver = {

  },

  lua_ls = {
    lua = {
      workspace = { checkthirdparty = false },
      telemetry = { enable = false },
    },
  },
}

-- setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- [[ configure nvim-cmp ]]
-- see `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

--react snipset
require('luasnip').filetype_extend("javascript", { "javascriptreact" })

--require('luasnip').filetype_extend("javascript", { "html" })

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<c-n>'] = cmp.mapping.select_next_item(),
    ['<c-p>'] = cmp.mapping.select_prev_item(),
    -- ['<c-d>'] = cmp.mapping.scroll_docs(-4),
    -- ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-space>'] = cmp.mapping.complete {},
    ['<cr>'] = cmp.mapping.confirm {
      behavior = cmp.confirmbehavior.replace,
      select = true,
    },
    ['<tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<s-tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    {
      name = 'path',
      option = {
        -- options go into this table
        trailing_slash= true,
        label_trailing_slash= true
      },

    },
    {
      name = 'buffer',
      option = {
	keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%([\-.]\w*\)*\)]],
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    }
  },
}

-- the line beneath this is called `modeline`. see `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

require'barbar'.setup {
    sidebar_filetypes = {
    -- use the default values: {event = 'bufwinleave', text = nil}
    nvimtree = true,
    -- or, specify the text used for the offset:
    -- undotree = {text = 'undotree'},
    -- or, specify the event which the sidebar executes when leaving:
    --['neo-tree'] = {event = 'bufwipeout'},
    -- or, specify both
    -- outline = {event = 'bufwinleave', text = 'symbols-outline'},
  },
}
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- move to previous/next
map('n', '<a-,>', '<cmd>bufferprevious<cr>', opts)
map('n', '<a-.>', '<cmd>buffernext<cr>', opts)
-- re-order to previous/next
map('n', '<a-<>', '<cmd>buffermoveprevious<cr>', opts)
map('n', '<a->>', '<cmd>buffermovenext<cr>', opts)
-- goto buffer in position...
map('n', '<a-1>', '<cmd>buffergoto 1<cr>', opts)
map('n', '<a-2>', '<cmd>buffergoto 2<cr>', opts)
map('n', '<a-3>', '<cmd>buffergoto 3<cr>', opts)
map('n', '<a-4>', '<cmd>buffergoto 4<cr>', opts)
map('n', '<a-5>', '<cmd>buffergoto 5<cr>', opts)
map('n', '<a-6>', '<cmd>buffergoto 6<cr>', opts)
map('n', '<a-7>', '<cmd>buffergoto 7<cr>', opts)
map('n', '<a-8>', '<cmd>buffergoto 8<cr>', opts)
map('n', '<a-9>', '<cmd>buffergoto 9<cr>', opts)
map('n', '<a-0>', '<cmd>bufferlast<cr>', opts)
-- pin/unpin buffer
map('n', '<a-p>', '<cmd>bufferpin<cr>', opts)
-- close buffer
map('n', '<a-c>', '<cmd>bufferclose<cr>', opts)
-- wipeout buffer
--                 :bufferwipeout
-- close commands
--                 :buffercloseallbutcurrent
--                 :buffercloseallbutpinned
--                 :buffercloseallbutcurrentorpinned
--                 :bufferclosebuffersleft
--                 :bufferclosebuffersright
-- magic buffer-picking mode
map('n', '<c-p>', '<cmd>bufferpick<cr>', opts)
-- sort automatically by...
map('n', '<space>bb', '<cmd>bufferorderbybuffernumber<cr>', opts)
map('n', '<space>bd', '<cmd>bufferorderbydirectory<cr>', opts)
map('n', '<space>bl', '<cmd>bufferorderbylanguage<cr>', opts)
map('n', '<space>bw', '<cmd>bufferorderbywindownumber<cr>', opts)

--theprimeagen keymaps
vim.keymap.set("v", "j", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "k", ":m '<-2<cr>gv=gv")

vim.keymap.set("n", "j", "mzj`z")
vim.keymap.set("n", "<c-d>", "<c-d>zz")
vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "n", "nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").startvimwithme()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").stopvimwithme()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dp]])
-- next greatest remap ever : asbjornhaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>y", [["+y]])
vim.keymap.set("i", "<c-c>", "<esc>")

--nvim tree
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
-- nvim tree keymaps
vim.keymap.set("n", "<a-b>", vim.cmd.nvimtreetoggle)
vim.keymap.set("n", "<a-e>", vim.cmd.nvimtreefocus)

-- keymap for undotree
vim.keymap.set('n', '<leader>u', vim.cmd.undotreetoggle, { desc = 'toggleundotree' })

--auto pair 
require('nvim-autopairs').setup({
  disable_filetype = { "telescopeprompt" , "vim" },
})
-- connect line
vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
    -- char_highlight_list = {
    --     "indentblanklineindent1",
    --     "indentblanklineindent2",
    --     "indentblanklineindent3",
    --     "indentblanklineindent4",
    --     "indentblanklineindent5",
    --     "indentblanklineindent6",
    -- },
}
--icon
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- devicon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
 -- globally enable "strict" selection of icons - icon will be looked up in
 -- different tables, first by filename, and if not found by extension; this
 -- prevents cases when file doesn't have any extension but still gets some icon
 -- because its name happened to match some extension (default to false)
 strict = true;
 -- same as `override` but specifically for overrides by filename
 -- takes effect when `strict` is true
 override_by_filename = {
  [".gitignore"] = {
    icon = "",
    color = "#f1502f",
    name = "gitignore"
  }
 };
 -- same as `override` but specifically for overrides by extension
 -- takes effect when `strict` is true
 override_by_extension = {
  ["log"] = {
    icon = "",
    color = "#81e043",
    name = "log"
  }
 };
}

-- trouble
vim.keymap.set("n", "<leader>xx", "<cmd>troubletoggle<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xw", "<cmd>troubletoggle workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xd", "<cmd>troubletoggle document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xl", "<cmd>troubletoggle loclist<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>xq", "<cmd>troubletoggle quickfix<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "gr", "<cmd>troubletoggle lsp_references<cr>",
  {silent = true, noremap = true}
)
local null_ls = require("null-ls")
local eslint = require("eslint")

null_ls.setup()

eslint.setup({
  bin = 'eslint', -- or `eslint_d`
  code_actions = {
    enable = true,
    apply_on_save = {
      enable = true,
      types = { "directive", "problem", "suggestion", "layout" },
    },
    disable_rule_comment = {
      enable = true,
      location = "separate_line", -- or `same_line`
    },
  },
  diagnostics = {
    enable = true,
    report_unused_disable_directives = false,
    run_on = "type", -- or `save`
  },
})
--transparent
vim.cmd('hi normal guibg=none ctermbg=none')
vim.cmd('hi endofbuffer guibg=none ctermbg=none')
vim.cmd('hi nvimtreeendofbuffer guibg=none ctermbg=none')
vim.cmd[[hi nvimtreenormal guibg=none ctermbg=none]]
-- other:
-- :barbarenable - enables barbar (enabled by default)
-- :barbardisable - very bad command, should never be used
