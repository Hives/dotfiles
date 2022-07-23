require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use 'L3MON4D3/LuaSnip'
    use "saadparwaiz1/cmp_luasnip"
    use "hrsh7th/cmp-nvim-lsp"

    use "rafamadriz/friendly-snippets"

    use "williamboman/nvim-lsp-installer"
    use "neovim/nvim-lspconfig"

    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use 'christoomey/vim-tmux-navigator' -- Seamless navigation between tmux panes and vim splits

    use 'wincent/terminus' -- enhanced terminal integration including mouse stuff
    use 'wincent/loupe' -- Enhanced in-file search for Vim

    use "windwp/nvim-autopairs"

    use 'chriskempson/base16-vim'

    use 'itchyny/lightline.vim'
    use 'Hives/vim-base16-lightline'

    use 'tpope/vim-sleuth' -- detect tab settings automatically

    use 'tpope/vim-fugitive' -- detect tab settings automatically

    use 'numToStr/Comment.nvim'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use 'JoosepAlviste/nvim-ts-context-commentstring'
end)

