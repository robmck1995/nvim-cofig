-- Packer bootstrap code
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

require('wincent.commandt').setup()

-- Auto-compile when there are changes in plugins.lua
vim.cmd [[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]]

local packer = require('packer')
packer.startup(function(use)
  -- Plugins
  use 'wbthomason/packer.nvim'
  use 'nvim-tree/nvim-tree.lua'
  use 'f-person/git-blame.nvim'
  use 'github/copilot.vim'
  use 'wincent/command-t'
  use 'rktjmp/lush.nvim'
  use 'mcchrish/zenbones.nvim'
  use 'tomasiser/vim-code-dark'
  use {'nvim-telescope/telescope.nvim', tag = '0.1.5', requires = { 'nvim-lua/plenary.nvim' }}
  use 'jremmen/vim-ripgrep'
  use 'neoclide/coc.nvim'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- Post-plugin-load configurations
  packer.on_complete = function()
    require('telescope').setup{
      defaults = { 
        file_ignore_patterns = { "package-lock.json", "poetry.lock" }
      }
    }

    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      view = {
        width = 50,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
    })

    vim.g.copilot_no_tab_map = true;
  end
end)

-- Set colorscheme
vim.cmd [[colorscheme codedark]]

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- General options
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.foldmethod = 'syntax'
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.api.nvim_set_option("clipboard","unnamed")
vim.opt.wildignore:append("node_modules/*")

-- Keymaps
vim.keymap.set({'n'}, '<Leader>t', '<cmd>CommandT<cr>')
vim.keymap.set({'n'}, '<Leader>w', '<cmd>NvimTreeOpen<cr>')
vim.keymap.set({'n'}, '<Leader>r', '<cmd>Telescope live_grep<cr>')

local keyset = vim.keymap.set
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Treesitter configuration
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",  -- Adjusted to "all" for simplicity or specify your languages
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
          return true
      end
      return false  -- ensure default highlighting isn't disabled accidentally
    end,
    additional_vim_regex_highlighting = false,
  },
}
