return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'nanotech/jellybeans.vim'

  use 'vim-airline/vim-airline'

  use {'neoclide/coc.nvim', branch = 'release'}

  use 'ctrlpvim/ctrlp.vim'

  use 'tpope/vim-commentary'

  use 'elixir-editors/vim-elixir'

  use {
    'w0rp/ale',
    ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'elixir', 'html', 'markdown', 'python', 'rust', 'vim', 'tex'},
    cmd = 'ALEEnable',
    config = 'vim.cmd[[ALEEnable]]'
  }
end)
