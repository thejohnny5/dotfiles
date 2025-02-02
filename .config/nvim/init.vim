" General Settings
set scrolloff=10
set number
set relativenumber
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set guicursor=n-v-c-i:block
let mapleader = " "

" File Explorer
nnoremap <leader>pv :Vex<CR>

" Reload Config
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>

call plug#begin('~/.local/share/nvim/plugged')

" Themes and UI Enhancements
Plug 'folke/tokyonight.nvim'

" Telescope and Utility Plugins
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }

" Syntax Highlighting and Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" LSP and Autocompletion
Plug 'neovim/nvim-lspconfig'
Plug 'nvimdev/lspsaga.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" Python Formatting
Plug 'psf/black', { 'branch': 'stable' }

" Zig LSP Integration
Plug 'ziglang/zig.vim'

call plug#end()

" Set Colorscheme
colorscheme tokyonight

" Telescope Keybindings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Quickfix Navigation
nnoremap <C-j> :cnext<CR>
nnoremap <C-k> :cprev<CR>

" Enable Treesitter Syntax Highlighting
lua << EOF

EOF

" LSP Configurations
lua << EOF
local lspconfig = require'lspconfig'

-- Python LSP (pyright)
lspconfig.pyright.setup{}

-- Zig LSP
lspconfig.zls.setup{}

-- Other language servers
lspconfig.clangd.setup{}
lspconfig.gopls.setup{}
-- Lspsaga (UI Enhancements for LSP)
require'lspsaga'.setup{}
EOF

" Autocompletion Configuration
lua << EOF
local cmp = require'cmp'
cmp.setup({
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    }),
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    })
})
EOF

" Format on Save for Python and Zig
autocmd BufWritePre *.py execute ':Black'
autocmd BufWritePre *.zig lua vim.lsp.buf.format()
