"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install plugins.
" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')

" Code completion.
Plug 'elixir-lsp/elixir-ls', { 'do': { -> g:ElixirLS.compile() } }
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Plug 'tpope/vim-endwise'
Plug 'dense-analysis/ale'

Plug 'elixir-editors/vim-elixir'

" Adds file type icons to Vim plugins.
" Get a Nerd Font! or patch your own. Without this, things break
Plug 'ryanoasis/vim-devicons'

"Plug 'airblade/vim-gitgutter'
"Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" Plugin offers tree view of files.
Plug 'preservim/nerdtree'
" Make NERDTree tabs more comfortable.
Plug 'jistr/vim-nerdtree-tabs'


" Fuzzy finder.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" Beautify vim statsline.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Switch between windows quickly.
Plug 'christoomey/vim-tmux-navigator'

" colorscheme
" Plug 'morhetz/gruvbox'
Plug 'HerringtonDarkholme/yats.vim' " TS Syntax

Plug 'hardcoreplayers/oceanic-material'

" Quick comment
Plug 'preservim/nerdcommenter' 

" Auto generate documentation.
Plug 'kkoomen/vim-doge'

" Easy align.
Plug 'junegunn/vim-easy-align'

" Rainbow bracket to make bracket more readable.
Plug 'luochen1990/rainbow'

Plug 'arcticicestudio/nord-vim'

" Bring smooth scrolling to vim.
" Plug 'yuttie/comfortable-motion.vim'

" Jedi vim, go to definition.
" Plug 'davidhalter/jedi-vim'


call plug#end()

let g:ale_linters = {
\   'elixir': ['elixir-ls'],
\}

let g:ale_fixers = {
\   'elixir': ['mix_format'],
\}

let g:ale_completion_enabled = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:ale_linters_explicit = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

noremap <Leader>ad :ALEGoToDefinition<CR>
nnoremap <leader>af :ALEFix<cr>
noremap <Leader>ar :ALEFindReferences<CR>

"Move between linting errors
"nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>





let g:coc_global_extensions = ['coc-elixir', 'coc-diagnostic']
let g:ElixirLS = {}
let ElixirLS.path = stdpath('config').'/plugged/elixir-ls'
let ElixirLS.lsp = ElixirLS.path.'/release/language_server.sh'
let ElixirLS.cmd = join([
        \ 'asdf install &&',
        \ 'mix do',
        \ 'local.hex --force --if-missing,',
        \ 'local.rebar --force,',
        \ 'deps.get,',
        \ 'compile,',
        \ 'elixir_ls.release'
        \ ], ' ')
function ElixirLS.on_stdout(_job_id, data, _event)
  let self.output[-1] .= a:data[0]
  call extend(self.output, a:data[1:])
endfunction
let ElixirLS.on_stderr = function(ElixirLS.on_stdout)
function ElixirLS.on_exit(_job_id, exitcode, _event)
  if a:exitcode[0] == 0
    echom '>>> ElixirLS compiled'
  else
    echoerr join(self.output, ' ')
    echoerr '>>> ElixirLS compilation failed'
  endif
endfunction
function ElixirLS.compile()
  let me = copy(g:ElixirLS)
  let me.output = ['']
  echom '>>> compiling ElixirLS'
  let me.id = jobstart('cd ' . me.path . ' && git pull && ' . me.cmd, me)
endfunction
" If you want to wait on the compilation only when running :PlugUpdate
" then have the post-update hook use this function instead:
" function ElixirLS.compile_sync()
"   echom '>>> compiling ElixirLS'
"   silent call system(g:ElixirLS.cmd)
"   echom '>>> ElixirLS compiled'
" endfunction
" Then, update the Elixir language server
call coc#config('elixir', {
  \ 'command': g:ElixirLS.lsp,
  \ 'filetypes': ['elixir', 'eelixir']
  \})
call coc#config('elixir.pathToElixirLS', g:ElixirLS.lsp)




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-easy-align settings.
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdcommenter settings.
" Use <ctrl-/> to toggle comments in code.
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" doge settings.
" Choose one documentation style.
"let g:doge_doc_standard_python = 'numpy'
let g:doge_doc_standard_python = 'google'
" let g:doge_doc_standard_python = 'reST'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" rainbow settings.
" Activate rainbow plugin.
let g:rainbow_active = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree settings

" open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open file in new tab by default.
" let NERDTreeMapOpenInTab='<ENTER>'
let NERDTreeCustomOpenArgs={'file':{'where': 't'}}


" open NERDTree automatically when vim starts up on opening a directory
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" map a specific key or shortcut to open NERDTree
map <C-n> :NERDTreeToggle<CR>

" close vim if the only window left open is a NERDTree
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Let NERDTree igonre files
let NERDTreeIgnore = ['\.pyc$', '\.swp$', '__pycache__$']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Status line, use `:help coc-status` to see more info.
let g:airline#extensions#tabline#enabled = 1
let airline#extensions#coc#error_symbol = ''
let airline#extensions#coc#warning_symbol = '  '
let g:airline_theme='badwolf'  "可以自定义主题，这里使用 badwolf
" let g:lightline = {
" \ 'colorscheme': 'badwolf',
" \ 'active': {
" \   'left': [ [ 'mode', 'paste' ],
" \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
" \ },
" \ 'component_function': {
" \   'cocstatus': 'coc#status'
" \ },
" \ }
"set statusline^=%{StatusDiagnostic()}%{get(b:,'coc_current_function','')}

" autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Basic settings.
"
let g:oceanic_material_transparent_background = 1
set background=dark
colorscheme nord
"colorscheme oceanic_material
set updatetime=300
set signcolumn=yes
set shell=/bin/bash
set nu
set relativenumber
set laststatus=2
set expandtab       " Always use spaces instead of tabs.
set tabstop=2       " Tab width after characters. 
set shiftwidth=2    " Tab stop before characters.
set encoding=UTF-8
filetype plugin on
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" in `.vimrc` or `~/.config/nvim/init.vim`
syntax on
filetype plugin indent on

set wildmenu
set clipboard=unnamed

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc.vim settings.
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"




function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
 

" Remap for symbol renaming.
nmap <F2> <Plug>(coc-rename)


" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')


" Formatting selected code.
" Need install autopep8 first time running.
" Needless for me.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

