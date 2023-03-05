
function pluginSetup()
  -- Indicate first time installation
  local packer_bootstrap = false

  -- packer.nvim configuration
  local conf = {
    profile = {
    enable = true,
    threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

  -- Plugins
  local function plugins(use)
    use { "wbthomason/packer.nvim" }
    -- Better Netrw
    use {"tpope/vim-vinegar"}

    -- Notification
    -- use {
    --   "rcarriga/nvim",
    --   event = "VimEnter",
    --   config = function()
    --     vim.notify = require "notify"
    --   end,
    -- }

   use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
		}

    --     -- Treesitter
    -- use {
    --   "nvim-treesitter/nvim-treesitter",
    --   opt = true,
    --   event = "BufRead",
    --   run = ":TSUpdate",
    --   config = function()
    --     require("nvim-treesitter.configs").setup {
    --         -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    --         ensure_installed = "all",
        
    --         -- Install languages synchronously (only applied to `ensure_installed`)
    --         sync_install = false,
        
    --         highlight = {
    --           -- `false` will disable the whole extension
    --           enable = true,
    --         },
        
    --         incremental_selection = {
    --           enable = true,
    --           keymaps = {
    --             init_selection = "gnn",
    --             node_incremental = "grn",
    --             scope_incremental = "grc",
    --             node_decremental = "grm",
    --           },
    --         },
        
    --         indent = { enable = true },
        
    --         -- vim-matchup
    --         matchup = {
    --           enable = true,
    --         },
        
    --         -- nvim-treesitter-textobjects
    --         textobjects = {
    --           select = {
    --             enable = true,
        
    --             -- Automatically jump forward to textobj, similar to targets.vim
    --             lookahead = true,
        
    --             keymaps = {
    --               -- You can use the capture groups defined in textobjects.scm
    --               ["af"] = "@function.outer",
    --               ["if"] = "@function.inner",
    --               ["ac"] = "@class.outer",
    --               ["ic"] = "@class.inner",
    --             },
    --           },
        
    --           swap = {
    --             enable = true,
    --             swap_next = {
    --               ["<leader>rx"] = "@parameter.inner",
    --             },
    --             swap_previous = {
    --               ["<leader>rX"] = "@parameter.inner",
    --             },
    --           },
        
    --           move = {
    --             enable = true,
    --             set_jumps = true, -- whether to set jumps in the jumplist
    --             goto_next_start = {
    --               ["]m"] = "@function.outer",
    --               ["]]"] = "@class.outer",
    --             },
    --             goto_next_end = {
    --               ["]M"] = "@function.outer",
    --               ["]["] = "@class.outer",
    --             },
    --             goto_previous_start = {
    --               ["[m"] = "@function.outer",
    --               ["[["] = "@class.outer",
    --             },
    --             goto_previous_end = {
    --               ["[M"] = "@function.outer",
    --               ["[]"] = "@class.outer",
    --             },
    --           },
        
    --           lsp_interop = {
    --             enable = true,
    --             border = "none",
    --             peek_definition_code = {
    --               ["<leader>df"] = "@function.outer",
    --               ["<leader>dF"] = "@class.outer",
    --             },
    --           },
    --         },
        
    --         -- endwise
    --         endwise = {
    --           enable = true,
    --         },
    --       }

    --   end,
    --   requires = {
    --     { "nvim-treesitter/nvim-treesitter-textobjects" },
    --   },
    -- }

    use {
      "TimUntersberger/neogit",
      cmd = "Neogit",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        local status_ok, neogit = pcall(require, "neogit")
        if not status_ok then
          return
        end
        neogit.setup {}
      end,
    }

    use {'nvim-telescope/telescope.nvim', tag = '0.1.0',
          requires = { {'nvim-lua/plenary.nvim'} }
     }

     -- Completion
     use {
       "ms-jpq/coq_nvim",
       branch = "coq",
       event = "InsertEnter",
       opt = true,
       run = ":COQdeps",
       config = function()
         vim.cmd('COQnow -s')
       end,
       requires = {
         { "ms-jpq/coq.artifacts", branch = "artifacts" },
         { "ms-jpq/coq.thirdparty", branch = "3p", module = "coq_3p" },
       },
       disable = false,
     }

     use {
     "folke/which-key.nvim",
      config = function()
        require("which-key").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
        }
       end
     }

    use "savq/melange"
    use 'ThePrimeagen/vim-be-good'
    
    use 'lvimuser/lsp-inlayhints.nvim'
    
    use "rktjmp/lush.nvim"
    use 'metalelf0/jellybeans-nvim' 
	use "rebelot/kanagawa.nvim"


    
   use {
    'junnplus/lsp-setup.nvim',
    requires = {
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
    }
   }


    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  packer_init()

  local packer = require "packer"
  packer.init(conf)
  packer.startup(plugins)
end

pluginSetup()


vim.api.nvim_set_hl(0, "NormalFloat", {bg="#3B4252"})
vim.api.nvim_set_hl(0, "TelescopeNormal", {bg="#3B4252"})
vim.api.nvim_set_hl(0, "Pmenu", { fg="#FF0000", bg="blue" })

vim.cmd('colorscheme jellybeans-nvim')

local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

-- Better escape using jk in insert and terminal mode
keymap("i", "kj", "<ESC>", default_opts)

-- space as leader
vim.g.mapleader = ' '


 -- telescope remaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
require('lsp-setup').setup({
  servers = {
      gopls = {},
      rust_analyzer = {}
}
})


