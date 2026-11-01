-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- vim
vim.cmd([[  source ~/.config/nvim/setting.vim  ]])

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    'ahmedkhalf/project.nvim' ,
    'folke/noice.nvim' , 'rcarriga/nvim-notify' , 'MunifTanjim/nui.nvim' ,
    'kevinhwang91/nvim-hlslens' ,
    'MeanderingProgrammer/render-markdown.nvim' , 'nvim-treesitter/nvim-treesitter' ,
    'mhinz/vim-signify' ,
    'nvim-telescope/telescope.nvim' , 'nvim-lua/plenary.nvim' , 'BurntSushi/ripgrep'
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- clipboard
if vim.env.SSH_CLIENT or vim.env.SSH_CONNECTION or vim.env.SSH_TTY or vim.env.TERMUX_VERSION then
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      if vim.v.event.operator == 'y' then
        local seq = '\x1b]52;c;' .. vim.base64.encode(table.concat(vim.v.event.regcontents, '\n')) .. '\x07'
        if vim.env.TMUX then
          seq = '\x1bPtmux;' .. seq:gsub('\x1b', '\x1b\x1b') .. '\x1b\\'
        end
        io.stdout:write(seq)
      end
    end,
  })
end

-- noice
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

-- nvim-hlslens
require('hlslens').setup()

local kopts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)

-- nvim-notify
require("notify").setup({
    timeout = 750 ,
    stages = "static" ,
})

-- project.nvim
require("project_nvim").setup {
}
require('telescope').load_extension('projects')

-- telescope.nvim
require('telescope').setup{
  defaults = {
    layout_strategy = 'flex',
    path_display = { "smart" }
  }
}
vim.keymap.set('n', '<M-/>', function() require('telescope.builtin').live_grep({ grep_open_files = true, previewer = false }) end, opts)
vim.keymap.set('n', '<M-->', '<Cmd>Telescope git_status<CR>', opts)
vim.keymap.set('n', '<M-|>', '<Cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
vim.keymap.set('n', '<M-:>', '<Cmd>Telescope resume<CR>', opts)
vim.keymap.set('n', '<M-(>', '<Cmd>Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<M-)>', '<Cmd>Telescope grep_string<CR>', opts)
vim.keymap.set('n', '<M-<>', '<Cmd>Telescope find_files<CR>', opts)
vim.keymap.set('n', '<M->>', '<Cmd>Telescope projects<CR>', opts)
vim.keymap.set('n', '<M-]>', '<Cmd>Telescope buffers<CR>', opts)
vim.keymap.set('n', '<M-[>', '<Cmd>Telescope oldfiles<CR>', opts)
vim.keymap.set('n', '<M-}>', '<Cmd>Telescope marks<CR>', opts)
vim.keymap.set('n', '<M-{>', '<Cmd>Telescope notify<CR>', opts)
-- vertical
if vim.env.SSH_CLIENT or vim.env.SSH_CONNECTION or vim.env.SSH_TTY or vim.env.TERMUX_VERSION then
  require('telescope').setup{
    defaults = {
      layout_strategy = 'vertical',
      layout_config = {
        preview_cutoff = 0,
        vertical = {
          preview_height = 0.3
        }
      }
    }
  }
end

-- vim-signify
vim.keymap.set('n', '<A-j>', '<Plug>(signify-next-hunk)', opts)
vim.keymap.set('n', '<A-k>', '<Plug>(signify-prev-hunk)', opts)
