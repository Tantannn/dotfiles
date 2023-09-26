--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!
{}
  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/

  And then you can explore or search through `:help lua-guide`

Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
--  Map your Ctrl to Caplock
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
-- Install package manager
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

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  prefer_startup_root = false,

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-cmdline',
      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = "│" },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '[c', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'Go to Previous Hunk' })
        vim.keymap.set('n', ']c', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'Go to Next Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
      -- vim.cmd.style 'warmer'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',
    dependencies = {
    },
    opts = {}
  },
  {'JoosepAlviste/nvim-ts-context-commentstring'},
  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
  {'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.

      -- Set the filetypes which barbar will offset itself for
      sidebar_filetypes = {
        -- Use the default values: {event = 'BufWinLeave', text = nil}
        -- NvimTree = true,
        -- Or, specify the text used for the offset:
        undotree = {text = 'undotree'},
        -- Or, specify the event which the sidebar executes when leaving:
        -- ['neo-tree'] = {event = 'BufWipeout'},
        -- Or, specify both
        Outline = {event = 'BufWinLeave', text = 'symbols-outline'},
      },
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup {
        -- your config goes here
        -- or just leave it empty :)
        enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
        execution_message = {
          message = function() -- message to print on save
            return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
          end,
          dim = 0.18, -- dim the color of `message`
          cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
        },
        trigger_events = {"InsertLeave", "TextChanged"}, -- vim events that trigger auto-save. See :h events
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
  --trouble shooting
  {
    "folke/trouble.nvim",
    opts = {
      position = "bottom", -- position of the list can be: bottom, top, left, right
      height = 10, -- height of the trouble list when position is top or bottom
      width = 50, -- width of the list when position is left or right
      icons = true, -- use devicons for filenames
      mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
      severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
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
        switch_severity = "s", -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small popup with the full multiline message
        preview = "p", -- preview the diagnostic location
        close_folds = {"zM", "zm"}, -- close all folds
        open_folds = {"zR", "zr"}, -- open all folds
        toggle_fold = {"zA", "za"}, -- toggle fold of current file
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
  {'MunifTanjim/eslint.nvim'},

  --switch true/false
  {'andrewradev/switch.vim'},
  --tailwindcss
  {'sublimelsp/LSP-tailwindcss'},
  --vim surround 
  {
    "tpope/vim-surround",
    keys = {
      { "cs", "<Plug>Csurround", desc = "change surrounding #1 by #2" },
      { "ds", "<Plug>Dsurround", desc = "delete surrounding #1" },
      { "cS", "<Plug>CSurround", desc = "change surrounding #1 by #2 + new line" },
      { "ys", "<Plug>Ysurround", desc = "wraps #1 in #2 (surround)" },
      { "yS", "<Plug>YSurround", desc = "wraps #1 in #2 (surround) + new line" },
      { "yss", "<Plug>Yssurround", desc = "wraps line in #1 (surround)" },
      { "ySs", "<Plug>YSsurround", desc = "wraps line in #1 (surround) + new line" },
      { "ySS", "<Plug>YSsurround", desc = "wraps line in #1 (surround) + new line" },
      { "gs", "<Plug>VSurround", desc = "wraps visual selection in #1 (surround)", mode = "x" },
      { "gS", "<Plug>VgSurround", desc = "wraps visual selection in #1 (surround) + new line", mode = "x" },
    },
    init = function()
      vim.g.surround_no_mappings = 1
    end
  },
  --vim repeat
  {'tpope/vim-repeat'},
  --prettier
  {'MunifTanjim/prettier.nvim'},
  -- barbecue
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      theme = {

        normal = { fg = "#c0caf5", bold = true },
        separator = { fg = "#737aa2", bold = true },
      }
    },
  },
  -- lightspeed search
  {'ggandor/lightspeed.nvim'},
  -- css color
  {'NvChad/nvim-colorizer.lua'},
  {'ziontee113/color-picker.nvim'},
  --codeium AI
  {  'Exafunction/codeium.vim',
    config = function ()
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true })
      vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
      vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
    end},
  -- transparent
  {'xiyaowong/transparent.nvim'},
  --persistance
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
  },
  --terminal
  -- {'akinsho/toggleterm.nvim'},
  -- nav
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim"
    },
    keys = {
      {"<leader>dn", "<cmd>Navbuddy<cr>", desc = "[D]ocument [N]avigation"},
    },
    config = function ()
      local actions = require("nvim-navbuddy.actions")
      local navbuddy = require("nvim-navbuddy")
      navbuddy.setup({
        window = {
          border = "double"
        },
        mappings = {
          ["<esc>"] = actions.close(),        -- Close and cursor to original location
          ["q"] = actions.close(),

          ["j"] = actions.next_sibling(),     -- down
          ["k"] = actions.previous_sibling(), -- up

          ["h"] = actions.parent(),           -- Move to left panel
          ["l"] = actions.children(),         -- Move to right panel
          ["0"] = actions.root(),             -- Move to first panel

          ["v"] = actions.visual_name(),      -- Visual selection of name
          ["V"] = actions.visual_scope(),     -- Visual selection of scope

          ["y"] = actions.yank_name(),        -- Yank the name to system clipboard "+
          ["Y"] = actions.yank_scope(),       -- Yank the scope to system clipboard "+

          ["i"] = actions.insert_name(),      -- Insert at start of name
          ["I"] = actions.insert_scope(),     -- Insert at start of scope

          ["a"] = actions.append_name(),      -- Insert at end of name
          ["A"] = actions.append_scope(),     -- Insert at end of scope

          ["r"] = actions.rename(),           -- Rename currently focused symbol

          ["d"] = actions.delete(),           -- Delete scope

          ["f"] = actions.fold_create(),      -- Create fold of current scope
          ["F"] = actions.fold_delete(),      -- Delete fold of current scope

          ["c"] = actions.comment(),          -- Comment out current scope

          ["<enter>"] = actions.select(),     -- Goto selected symbol
          ["o"] = actions.select(),

          ["J"] = actions.move_down(),        -- Move focused node down
          ["K"] = actions.move_up(),          -- Move focused node up

          ["s"] = actions.toggle_preview(),   -- Show preview of current node

          ["<C-v>"] = actions.vsplit(),       -- Open selected node in a vertical split
          ["<C-s>"] = actions.hsplit(),

        },
        lsp = {auto_attach = true}
      })
    end
  },
  {'svban/YankAssassin.vim'},
  --beter esc
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        mapping = {"jk", "kj"}, -- a table with mappings to use
        timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        clear_empty_lines = false, -- clear line after escaping if there is only whitespace
        keys = "<Esc>", -- keys used for escaping, if it is a funct
      })
    end,
  },
  --tab-stop
  {'tpope/vim-sleuth'},
  -- todo-comments.nvim
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  -- better Mar
  { 'chentoast/marks.nvim' },
  -- toggle Terminal
  {'akinsho/toggleterm.nvim', version = "*", config = true},
  -- hardtime
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {  max_time = 1000,
      max_count = 2,
      disable_mouse = true,
      hint = true,
      notification = true,
      allow_different_key = false,
      enabled = true,
      resetting_keys = {
        ["1"] = { "n", "x" },
        ["2"] = { "n", "x" },
        ["3"] = { "n", "x" },
        ["4"] = { "n", "x" },
        ["5"] = { "n", "x" },
        ["6"] = { "n", "x" },
        ["7"] = { "n", "x" },
        ["8"] = { "n", "x" },
        ["9"] = { "n", "x" },
        ["c"] = { "n" },
        ["C"] = { "n" },
        ["d"] = { "n" },
        ["x"] = { "n" },
        ["X"] = { "n" },
        ["y"] = { "n" },
        ["Y"] = { "n" },
        ["p"] = { "n" },
        ["P"] = { "n" },
      },
      restriction_mode = "block", -- block or hint
      restricted_keys = {
        ["h"] = { "n", "x" },
        ["j"] = { "n", "x" },
        ["k"] = { "n", "x" },
        ["l"] = { "n", "x" },
        ["-"] = { "n", "x" },
        ["+"] = { "n", "x" },
        ["gj"] = { "n", "x" },
        ["gk"] = { "n", "x" },
        ["<CR>"] = { "n", "x" },
        ["<C-M>"] = { "n", "x" },
        ["<C-N>"] = { "n", "x" },
        ["<C-P>"] = { "n", "x" },
      },
      disabled_keys = {
        ["<Up>"] = { "", "i" },
        ["<Down>"] = { "", "i" },
        ["<Left>"] = { "", "i" },
        ["<Right>"] = { "", "i" },
      },
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason" },
      hints = {
        ["[kj][%^_]"] = {
          message = function(key)
            return "Use "
              .. (key:sub(1, 1) == "k" and "-" or "<CR> or +")
              .. " instead of "
              .. key
          end,
          length = 2,
        },
        ["%$a"] = {
          message = function()
            return "Use A instead of $a"
          end,
          length = 2,
        },
        ["%^i"] = {
          message = function()
            return "Use I instead of ^i"
          end,
          length = 2,
        },
        ["%D[k-]o"] = {
          message = function(keys)
            return "Use O instead of " .. keys:sub(2)
          end,
          length = 3,
        },
        ["%D[j+]O"] = {
          message = function(keys)
            return "Use o instead of " .. keys:sub(2)
          end,
          length = 3,
        },
        ["[^fFtT]li"] = {
          message = function()
            return "Use a instead of li"
          end,
          length = 3,
        },
        ["2([dcy=<>])%1"] = {
          message = function(key)
            return "Use " .. key:sub(3) .. "j instead of " .. key
          end,
          length = 3,
        },

        -- hints for f/F/t/T
        ["[^dcy=]f.h"] = {
          message = function(keys)
            return "Use t" .. keys:sub(3, 3) .. " instead of " .. keys:sub(2)
          end,
          length = 4,
        },
        ["[^dcy=]F.l"] = {
          message = function(keys)
            return "Use T" .. keys:sub(3, 3) .. " instead of " .. keys:sub(2)
          end,
          length = 4,
        },
        ["[^dcy=]T.h"] = {
          message = function(keys)
            return "Use F" .. keys:sub(3, 3) .. " instead of " .. keys:sub(2)
          end,
          length = 4,
        },
        ["[^dcy=]t.l"] = {
          message = function(keys)
            return "Use f" .. keys:sub(3, 3) .. " instead of " .. keys:sub(2)
          end,
          length = 4,
        },

        -- hints for delete + insert
        ["d[bBwWeE%^%$]i"] = {
          message = function(keys)
            return "Use " .. "c" .. keys:sub(2, 2) .. " instead of " .. keys
          end,
          length = 3,
        },
        ["dg[eE]i"] = {
          message = function(keys)
            return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
          end,
          length = 4,
        },
        ["d[tTfF].i"] = {
          message = function(keys)
            return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
          end,
          length = 4,
        },
        ["d[ia][\"'`{}%[%]()<>bBwWspt]i"] = {
          message = function(keys)
            return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
          end,
          length = 4,
        },

        -- hints for unnecessary visual mode
        ["Vgg[dcy=<>]"] = {
          message = function(keys)
            return "Use " .. keys:sub(4, 4) .. "gg instead of " .. keys
          end,
          length = 4,
        },
        ['Vgg".[dy]'] = {
          message = function(keys)
            return "Use " .. keys:sub(4, 6) .. "gg instead of " .. keys
          end,
          length = 6,
        },
        ["VG[dcy=<>]"] = {
          message = function(keys)
            return "Use " .. keys:sub(3, 3) .. "G instead of " .. keys
          end,
          length = 3,
        },
        ['VG".[dy]'] = {
          message = function(keys)
            return "Use " .. keys:sub(3, 5) .. "G instead of " .. keys
          end,
          length = 5,
        },
        ["V%d[kj][dcy=<>]"] = {
          message = function(keys)
            return "Use "
              .. keys:sub(4, 4)
              .. keys:sub(2, 3)
              .. " instead of "
              .. keys
          end,
          length = 4,
        },
        ['V%d[kj]".[dy]'] = {
          message = function(keys)
            return "Use "
              .. keys:sub(4, 6)
              .. keys:sub(2, 3)
              .. " instead of "
              .. keys
          end,
          length = 6,
        },
        ["V%d%d[kj][dcy=<>]"] = {
          message = function(keys)
            return "Use "
              .. keys:sub(5, 5)
              .. keys:sub(2, 4)
              .. " instead of "
              .. keys
          end,
          length = 5,
        },
        ['V%d%d[kj]".[dy]'] = {
          message = function(keys)
            return "Use "
              .. keys:sub(5, 7)
              .. keys:sub(2, 4)
              .. " instead of "
              .. keys
          end,
          length = 7,
        },
        ["[vV][bBwWeE%^%$][dcy=<>]"] = {
          message = function(keys)
            return "Use "
              .. keys:sub(3, 3)
              .. keys:sub(2, 2)
              .. " instead of "
              .. keys
          end,
          length = 3,
        },
        ['[vV][bBwWeE%^%$]".[dy]'] = {
          message = function(keys)
            return "Use "
              .. keys:sub(3, 5)
              .. keys:sub(2, 2)
              .. " instead of "
              .. keys
          end,
          length = 5,
        },
        ["[vV]g[eE][dcy=<>]"] = {
          message = function(keys)
            return "Use "
              .. keys:sub(4, 4)
              .. keys:sub(2, 3)
              .. " instead of "
              .. keys
          end,
          length = 4,
        },
        ['[vV]g[eE]".[dy]'] = {
          message = function(keys)
            return "Use "
              .. keys:sub(4, 6)
              .. keys:sub(2, 3)
              .. " instead of "
              .. keys
          end,
          length = 6,
        },
        ["[vV][tTfF].[dcy=<>]"] = {
          message = function(keys)
            return "Use "
              .. keys:sub(4, 4)
              .. keys:sub(2, 3)
              .. " instead of "
              .. keys
          end,
          length = 4,
        },
        ['[vV][tTfF].".[dy]'] = {
          message = function(keys)
            return "Use "
              .. keys:sub(4, 6)
              .. keys:sub(2, 3)
              .. " instead of "
              .. keys
          end,
          length = 6,
        },
        ["[vV][ia][\"'`{}%[%]()<>bBwWspt][dcy=<>]"] = {
          message = function(keys)
            return "Use "
              .. keys:sub(4, 4)
              .. keys:sub(2, 3)
              .. " instead of "
              .. keys
          end,
          length = 4,
        },
        ['[vV][ia]["\'`{}%[%]()<>bBwWspt]".[dy]'] = {
          message = function(keys)
            return "Use "
              .. keys:sub(4, 6)
              .. keys:sub(2, 3)
              .. " instead of "
              .. keys
          end,
          length = 6,
        },
      },}
 },
  {'OmniSharp/omnisharp-vim'},
  {'Hoffs/omnisharp-extended-lsp.nvim'},

  { import = 'custom.plugins' },
}, {})




-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Configure signcolumn on by default
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
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
vim.opt.splitright = true       -- Vertical split to the right
vim.opt.splitbelow = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sa', require('telescope.builtin').live_grep, { desc = '[S]earch in [A]ll files by Grep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim',  'html', 'javascript', 'css', 'html', 'scss' },

  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
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
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
  autotag = {
    enable = true,
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>qe', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>qq', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  clangd = {},
  -- gopls = {},
  pyright = {},
  rust_analyzer = {},
  omnisharp = {},
  tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

local pid = vim.fn.getpid()
-- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
local omnisharp_bin = "/home/tantannn/.cache/omnisharp-vim/omnisharp-roslyn/run"
-- on Windows
-- local omnisharp_bin = "/path/to/omnisharp/OmniSharp.exe"

local config = {
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler,
  },
  cmd = { omnisharp_bin, '--languageserver' , '--hostPID', tostring(pid) },
  -- rest of your settings
}

require'lspconfig'.omnisharp.setup(config)

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
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

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

--react snipset
require('luasnip').filetype_extend("javascript", { "javascriptreact" })

require('luasnip').filetype_extend("javascript", { "html" })

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    -- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
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
        -- Options go into this table
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
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
      { name = 'cmdline' }
    })
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

require('onedark').setup {
  style = 'darker'
}

require('onedark').load()
require'barbar'.setup {
  auto_hide = false,
  sidebar_filetypes = {
    -- Use the default values: {event = 'BufWinLeave', text = nil}
    NvimTree = true,
    -- Or, specify the text used for the offset:
    undotree = {text = 'undotree'},
    -- Or, specify the event which the sidebar executes when leaving:
    --['neo-tree'] = {event = 'BufWipeout'},
    -- Or, specify both
    -- Outline = {event = 'BufWinLeave', text = 'symbols-outline'},
  },

}
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

--ThePrimeagen keymaps
vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])
-- vim.keymap.set("i", "<C-c>", "<Esc>")
-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
vim.keymap.set("n", "<leader>qc", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],{ desc = 'Change all word' } )

-- my custom keymaps
vim.keymap.set("n", "<leader>o", "o<Esc>")
vim.keymap.set("n", "<leader>O", "O<Esc>")
vim.keymap.set("n", "<BS>", "ciw", {desc = 'Delete a word'})
-- vim.keymap.set("i", "<C-BS>", "<Esc>cvb",{desc = 'Delete a word'})
-- vim.keymap.set("i", "<C-H>", "<Esc>cvb",{desc = 'Delete a word'})
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("i", "<C-b>", "<Esc>^i", {desc= "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", {desc= "End of line" })
-- vim.keymap.set("n", "<Tab>", "%", {desc= "Jump between brackets" })

-- navigate within insert mode
vim.keymap.set("i", "<C-h>", "<Left>", {desc= "Move left" })
vim.keymap.set("i", "<C-l>", "<Right>", {desc= "Move right" })
vim.keymap.set("i", "<C-j>", "<Down>", {desc= "Move down" })
vim.keymap.set("i", "<C-k>", "<Up>", {desc= "Move up" })

-- Use <Tab> to cycle through buffers in tab
vim.keymap.set('n', '<Tab>', '<C-W>w');
vim.keymap.set('n', '<S-Tab>', '<C-W>W');
-- vim.keymap.set('n', '<C-j>', '<C-W>j', { desc = 'Go to down window' });
-- vim.keymap.set('n', '<C-k>', '<C-W>k', { desc = 'Go to up window' });
-- vim.keymap.set('n', '<C-h>', '<C-W>h', { desc = 'Go to left window' });
-- vim.keymap.set('n', '<C-l>', '<C-W>l', { desc = 'Go to right window' });
vim.keymap.set("n", "<C-n>", "*Ncgn", { silent = true, desc = "Substitute word under cursor" })

-- Resize with arrows
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', {desc = "Resize window up"});
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', {desc = "Resize window down"});
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', {desc = "Resize window left"});
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', {desc = "Resize window right"});

-- Toggle Term 
-- nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
-- inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
vim.keymap.set('n', '<C-t>', ':ToggleTerm<CR>', {desc = "Toggle Term"});
vim.keymap.set('i', '<C-t>', ':ToggleTerm<CR>', {desc = "Toggle Term"});
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
--nvim tree
require("nvim-tree").setup({
  filters = {
    dotfiles = false,
    exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
  },
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    adaptive_size = false,
    side = "left",
    width = 30,
    preserve_window_proportions = true,
  },
  git = {
    enable = false,
    ignore = true,
  },
  filesystem_watchers = {
    enable = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    root_folder_label = false,
    highlight_git = false,
    highlight_opened_files = "none",

    indent_markers = {
      enable = false,
    },

    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
      },

      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },

})
-- nvim tree keymaps
vim.keymap.set("n", "<A-b>", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<A-e>", vim.cmd.NvimTreeFocus)

-- keymaps for undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'ToggleUndoTree' })

-- prettier keymap
vim.keymap.set("n", "<leader>f", vim.cmd.Prettier, { desc = 'Prettier format'})

local prettier = require("prettier")

prettier.setup({
  bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
  cli_options = {
    single_quote = false,
    tab_width = 4,
  }
})
--auto pair 
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})

-- switch true/false keymap
vim.g.switch_mapping = ''

-- connect line
vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
  space_char_blankline = " ",
  show_current_context = true,
  -- show_current_context_start = true,
  -- char_highlight_list = {
  --     "IndentBlanklineIndent1",
  --     "IndentBlanklineIndent2",
  --     "IndentBlanklineIndent3",
  --     "IndentBlanklineIndent4",
  --     "IndentBlanklineIndent5",
  --     "IndentBlanklineIndent6",
  -- },
}
--icon
require'nvim-web-devicons'.setup {
  -- your personnal icons can go here (to override)
  -- you can specify color or cterm_color instead of specifying both of them
  -- DevIcon will be appended to `name`
  override = {
    zsh = {
      icon = "",
      color = "#428850",
      cterm_color = "65",
      name = "Zsh"
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
      name = "Gitignore"
    }
  };
  -- same as `override` but specifically for overrides by extension
  -- takes effect when `strict` is true
  override_by_extension = {
    ["log"] = {
      icon = "",
      color = "#81e043",
      name = "Log"
    }
  };
}

-- trouble
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>")
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>")
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>")
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>")
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>")
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
-- vim.cmd('hi normal guibg=none ctermbg=none')
-- vim.cmd('hi endofbuffer guibg=none ctermbg=none')
vim.cmd('hi nvimtreeendofbuffer guibg=none ctermbg=none')
vim.cmd[[hi nvimtreenormal guibg=none ctermbg=none]]

--barbecue custom theme
-- require("barbecue").setup({
--   theme = {
--     -- this highlight is used to override other highlights
--     -- you can take advantage of its `bg` and set a background throughout your winbar
--     -- (e.g. basename will look like this: { fg = "#c0caf5", bold = true })
--     normal = { fg = "#c0caf5" }
--
--     -- these highlights correspond to symbols table from config
--     -- ellipsis = { fg = "#737aa2" },
--     -- separator = { fg = "#737aa2" },
--     -- modified = { fg = "#737aa2" },
--     --
--     -- these highlights represent the _text_ of three main parts of barbecue
--     -- dirname = { fg = "#737aa2" },
--     -- basename = { bold = true },
--     -- context = {},
--
--     -- these highlights are used for context/navic icons
--     -- context_file = { fg = "#ac8fe4" },
--     -- context_module = { fg = "#ac8fe4" },
--     -- context_namespace = { fg = "#ac8fe4" },
--     -- context_package = { fg = "#ac8fe4" },
--     -- context_class = { fg = "#ac8fe4" },
--     -- context_method = { fg = "#ac8fe4" },
--     -- context_property = { fg = "#ac8fe4" },
--     -- context_field = { fg = "#ac8fe4" },
--     -- context_constructor = { fg = "#ac8fe4" },
--     -- context_enum = { fg = "#ac8fe4" },
--     -- context_interface = { fg = "#ac8fe4" },
--     -- context_function = { fg = "#ac8fe4" },
--     -- context_variable = { fg = "#ac8fe4" },
--     -- context_constant = { fg = "#ac8fe4" },
--     -- context_string = { fg = "#ac8fe4" },
--     -- context_number = { fg = "#ac8fe4" },
--     -- context_boolean = { fg = "#ac8fe4" },
--     -- context_array = { fg = "#ac8fe4" },
--     -- context_object = { fg = "#ac8fe4" },
--     -- context_key = { fg = "#ac8fe4" },
--     -- context_null = { fg = "#ac8fe4" },
--     -- context_enum_member = { fg = "#ac8fe4" },
--     -- context_struct = { fg = "#ac8fe4" },
--     -- context_event = { fg = "#ac8fe4" },
--     -- context_operator = { fg = "#ac8fe4" },
--     -- context_type_parameter = { fg = "#ac8fe4" },
--     --
--   },
-- })
--
-- require("nvim-navic").setup({
--     icons = {
--         File          = "󰈙 ",
--         Module        = " ",
--         Namespace     = "󰌗 ",
--         Package       = " ",
--         Class         = "󰌗 ",
--         Method        = "󰆧 ",
--         Property      = " ",
--         Field         = " ",
--         Constructor   = " ",
--         Enum          = "󰕘",
--         Interface     = "󰕘",
--         Function      = "󰊕 ",
--         Variable      = "󰆧 ",
--         Constant      = "󰏿 ",
--         String        = "󰀬 ",
--         Number        = "󰎠 ",
--         Boolean       = "◩ ",
--         Array         = "󰅪 ",
--         Object        = "󰅩 ",
--         Key           = "󰌋 ",
--         Null          = "󰟢 ",
--         EnumMember    = " ",
--         Struct        = "󰌗 ",
--         Event         = " ",
--         Operator      = "󰆕 ",
--         TypeParameter = "󰊄 ",
--     },
--     -- lsp = {
--     --     auto_attach = false,
--     --     preference = nil,
--     -- },
--     highlight = false,
--     separator = " > ",
--     depth_limit = 0,
--     depth_limit_indicator = "..",
--     safe_output = true,
--     click = false
-- })

-- css color 
vim.keymap.set("n", "<C-q>", "<cmd>PickColor<cr>", opts)
vim.keymap.set("i", "<C-q>", "<cmd>PickColorInsert<cr>", opts)

require('colorizer').setup({
  filetypes = {
    'css',
    'javascript',
    'html'
  },
  user_default_options = {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = true, -- "Name" codes like Blue or blue
    RRGGBBAA = false, -- #RRGGBBAA hex codes
    AARRGGBB = false, -- 0xAARRGGBB hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    rgba_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = false, -- CSS hsl() and hsla() functions
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    -- Available modes for `mode`: foreground, background,  virtualtext
    mode = "background", -- Set the display mode.
    -- Available methods are false / true / "normal" / "lsp" / "both"
    -- True is same as normal
    tailwind = true, -- Enable tailwind colors
    -- parsers can contain values used in |user_default_options|
    sass = { enable = true, parsers = { "css" }, }, -- Enable sass colors
    virtualtext = "■",
    -- update color values even if buffer is not focused
    -- example use: cmp_menu, cmp_docs
    always_update = true
  },
  -- all the sub-options of filetypes apply to buftypes
  buftypes = {}
})

-- vim.keymap.set("n", "your_keymap", "<cmd>ConvertHEXandRGB<cr>", opts)
-- vim.keymap.set("n", "your_keymap", "<cmd>ConvertHEXandHSL<cr>", opts)

require("color-picker").setup({ -- for changing icons & mappings
  ["icons"] = { "ﱢ", "" },
  -- ["icons"] = { "ﮊ", "" },
  -- ["icons"] = { "", "ﰕ" },
  -- ["icons"] = { "", "" },
  -- ["icons"] = { "", "" },
  -- ["icons"] = { "ﱢ", "" },
  ["border"] = "rounded", -- none | single | double | rounded | solid | shadow
  ["keymap"] = { -- mapping example:
    ["U"] = "<Plug>ColorPickerSlider5Decrease",
    ["O"] = "<Plug>ColorPickerSlider5Increase",
  },
  ["background_highlight_group"] = "Normal", -- default
  ["border_highlight_group"] = "FloatBorder", -- default
  ["text_highlight_group"] = "Normal", --default
})

vim.cmd([[hi FloatBorder guibg=NONE]])

--comment
require('Comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}
require( 'persistence' ).setup {
  dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
  options = {"buffers", "curdir", "tabpages", "winsize", 'globals'},
  pre_save = function() vim.api.nvim_exec_autocmds('User', {pattern = 'SessionSavePre'}) end,
}
-- restore the session for the current directory
vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {})

-- restore the last session
vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})

-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], {})

-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } }, 
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  function()
    return '▊'
  end,
  color = { fg = colors.blue }, -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this
}

ins_left {
  -- mode component
  function()
    return ''
  end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
}


ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.magenta, gui = 'bold' },
}

ins_left { 'location' }

ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
  function()
    return '%='
  end,
}



-- Add components to right sections
ins_right {
  'o:encoding', -- option component same as &encoding in viml
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'fileformat',
  fmt = string.upper,
  icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'branch',
  icon = '',
  color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
  'diff',
  -- Is it me or the symbol for modified us really weird
  symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

ins_right {
  function()
    return '▊'
  end,
  color = { fg = colors.blue },
  padding = { left = 1 },
}

-- Now don't forget to initialize lualine
lualine.setup(config)

--better Mark 
require'marks'.setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions. 
  -- higher values will have better performance but may cause visual lag, 
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world",
    -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
    -- defaults to false.
    annotate = false,
  },
  mappings = {}
}

-- telescope picker/ resume
