" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" install onedark theme https://github.com/joshdick/onedark.vim
Plug 'joshdick/onedark.vim'

" language packs for vim https://github.com/sheerun/vim-polyglot
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release' }
Plug 'editorconfig/editorconfig-vim'

" status line shown on the right hand of the vim editor
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim' " statusline for tmux

" allows to zoom and restore via \\
Plug 'regedarek/ZoomWin'

" shows indent line for code blocks
Plug 'Yggdroot/indentLine'

" error preview https://github.com/dense-analysis/ale
Plug 'w0rp/ale'

" show tree view
Plug 'sjl/gundo.vim'

" further plugins
Plug 'ctrlpvim/ctrlp.vim', { 'on': 'CtrlP' }
Plug 'mileszs/ack.vim', { 'on': 'Ack' }
Plug 'tomtom/tcomment_vim', { 'on': 'TComment' }
Plug 'tpope/vim-unimpaired'
Plug 'chrisbra/matchit'
Plug 'AndrewRadev/splitjoin.vim'

" editor assistance
Plug 'junegunn/vim-easy-align'
Plug 'michaeljsmith/vim-indent-object'
Plug 'lukaszb/vim-web-indent'
Plug 'wellle/targets.vim'

" Initialize plugin system
call plug#end()

"From https://github.com/joshdick/onedark.vim
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

" overrides for onedark theme
" https://github.com/joshdick/onedark.vim/blob/master/colors/onedark.vim
let g:onedark_termcolors=256
let g:onedark_color_overrides = {
\ "black": {"gui": "#282C34", "cterm": "235", "cterm16": "0" },
\}

syntax on
colorscheme onedark

" Basic rules {{{
    " the title of the window will be set to the value of 'titlestring'
    " (if it is not empty), or to: filename [+=-] (path) - VIM
    set title
    set nospell
    set mouse=a
    " make it easy
    nmap <Space> :
    " annoying window
    map q: :q
"}}}

" Appearance {{{
set ruler
    syntax on
    set synmaxcol=300 " Syntax coloring lines that are too long just slows down the world
    set cursorline

    set visualbell
    set scrolloff=3
    set showcmd

    set nu
    let lines = str2nr(line('$'))

    set numberwidth=5

    " Status bar {{{
        set laststatus=2
    "}}}
"}}}

" Whitespace and indentation {{{
    set nowrap

    set tabstop=4
    set shiftwidth=4
    set softtabstop=4
    set expandtab

    " Round indent to multiple of 'shiftwidth'.
    " Indentation always be multiple of shiftwidth
    " Applies to  < and > command
    set shiftround

    " Invisible characters
    set list
    if has('multi_byte')
        if version >= 700
            set listchars=tab:\ \ ,trail:·,extends:→,nbsp:×
        else
            set listchars=tab:\ \ ,trail:·,extends:>,nbsp:_
        endif
    endif
    if has("linebreak")
        let &sbr = nr2char(8618).' '  " Show ↪ at the beginning of wrapped lines
    endif

    " allow backspacing over everything in insert mode
    set backspace=indent,eol,start

    " load the plugin and indent settings for the detected filetype
    filetype plugin indent on

    " Indent ala Textmate
    imap <D-[> <ESC><<
    imap <D-]> <ESC>>>
    nmap <D-[> <<
    nmap <D-]> >>
    vmap <D-[> <gv
    vmap <D-]> >gv

    vnoremap < <gv
    vnoremap > >gv

    " Remove the Windows ^M - when the encodings gets messed up
    noremap <Leader>mm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

    " Strip trailing whitespace
    function! StripWhitespace ()
        exec ':%s/ \+$//gc'
    endfunction
    map <Leader>sw :call StripWhitespace ()<CR>

    " CSScomb
    function! CSScomb()
        execute "silent !csscomb " . expand('%')
        redraw!
    endfunction
"}}}

" Searching and Replacing {{{
    set hlsearch
    set incsearch
    set ignorecase
    set smartcase

    " mapping to disable search highlight
    nmap <silent> <Leader><Space> :noh<CR>

    " always on center of the window
    " nmap n nzz
    " nmap N Nzz
    " nmap * *zz
    " nmap # #zz
    " nmap g* g*zz
    " nmap g# g#zz

    set gdefault "set 'g' by default in commands like :%s/../.../

    " map to fast search/replace
    nnoremap <leader>s :%s//<left>
"}}}

" Tab completion {{{
    set wildmode=list:longest,list:full
    set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,*/build/*,*/dist/*,*/node_modules/*,*/coverage/*,*.egg-info,*.egg_link,*/south_migrations/*,*/django_migrations/*,*/env/*,*/cms-test-env/*,data/media/filer_public/*
"}}}

" Window manipulation {{{
    set splitbelow
    set splitright

    nmap <C-h> <C-w>h
    nmap <C-j> <C-w>j
    nmap <C-k> <C-w>k
    nmap <C-l> <C-w>l

    nmap <Up>    5<C-w>+
    nmap <Down>  5<C-w>-
    nmap <Left>  5<C-w><
    nmap <Right> 5<C-w>>
"}}}

" Folding {{{
    set foldenable                " Turn on folding
    set foldmethod=manual
    "set foldlevel=100            " Don't autofold anything (but I can still fold manually)

    set foldopen=block,hor,tag    " what movements open folds
    set foldopen+=percent,mark
    set foldopen+=quickfix,search
"}}}

" Files manipulation {{{
    nnoremap <leader>w   <C-w>v
    nnoremap <leader>we  <C-w>v:e <C-R>=expand("%:p:h") . "/" <CR>
    nnoremap <leader>se  <C-w>s:e <C-R>=expand("%:p:h") . "/" <CR>
    nnoremap <leader>ve  <C-w>v:e ~/.vim/vimrc<CR>
    nnoremap <leader>vge <C-w>v:e ~/.vim/gvimrc<CR>

    " Opens an edit command with the path of the currently edited file filled in
    " Normal mode: <Leader>e
    map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

    " Opens a tab edit command with the path of the currently edited file filled in
    " Normal mode: <Leader>t
    map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

    " Inserts the path of the currently edited file into a command
    " Command mode: Ctrl+P
    cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

    " cd to the directory containing the file in the buffer
    nmap  <leader>cd :lcd <C-R>=expand("%:p:h")<CR><CR>

    " Create parent directory on save if does not exist
    augroup BWCCreateDir
        au!
        autocmd BufWritePre,BufNewFile * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
    augroup END

    " save file with root permissions
    cmap w!! %!sudo tee > /dev/null %

    " map command wq wa qa in russian
    cmap ц w
    cmap ф a
    cmap й q

    " Editing files {{{
        nnoremap K <nop>
        nnoremap K i<CR><ESC>

        set pastetoggle=<F10>

        " html escape/unescape
        " via: http://vim.wikia.com/wiki/HTML_entities
        function! HtmlEscape()
          silent s/&/\&amp;/e
          silent s/</\&lt;/e
          silent s/>/\&gt;/e
        endfunction

        function! HtmlUnEscape()
          silent s/&lt;/</e
          silent s/&gt;/>/e
          silent s/&amp;/\&/e
        endfunction

        map <silent> <Leader>he :call HtmlEscape()<CR>
        map <silent> <Leader>hu :call HtmlUnEscape()<CR>
    "}}}

    " Moving in file {{{
        nmap <tab> %
        vmap <tab> %

        " Move in insert mode like in command line
        imap <C-e> <C-o>A
        imap <C-a> <C-o>I
    "}}}

    " File formatting {{{
        set fo-=o  " Do not insert the current comment leader after hitting 'o' or 'O' in Normal mode.
        set fo+=r  " Automatically insert a comment leader after an enter
    "}}}

    " Remember last location in file {{{
    if has("autocmd")
      au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif
    endif
    "}}}

    " Helper functions {{{
    fun! DetectDjangoTemplate()
        let n = 1
        while n < line("$")
            if getline(n) =~ '{%' || getline(n) =~ '{{'
                set ft=htmldjango
                return
            endif
            let n = n + 1
        endwhile
        set ft=html "default html
    endfun

    fun! DetectMinifiedJavaScriptFile()
        let n = 1
        while n < line("$")
            if len(getline(n)) >= 500
                " set syntastic to off
                let b:syntastic_skip_checks = 1
                SyntasticReset
                return
            endif
            let n = n + 1
        endwhile
    endfun

    " Somewhat hackish way to enable vim-jsx
    " If i don't do that - it will set ft=javascript.jsx on
    " every javascript file, which in turn makes Tcomment to
    " always use {/* comments like this */} which makes me sad.
    fun! DetectJSX()
        let n = 1
        let b:jsx_pragma_found = 0
        while n < line("$")
            if getline(n) =~ 'React' || getline(n) =~ 'react'
                " set syntax to jsx
                " let b:jsx_pragma_found = 1
                set filetype=javascript.jsx
                return
            endif
            let n = n + 1
        endwhile
    endfun
    "}}}
"}}}

" Filetype autocommands {{{
    if has("autocmd")
        " make uses real tabs
        au FileType make  set noexpandtab
        " Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
        au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby
        " md, markdown, and mk are markdown and define buffer-local preview
        au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn}  map <buffer> <Leader>p :Hammer <CR>
        " make python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
        au FileType python  set tabstop=4 textwidth=79
        au BufRead,BufNewFile *.yml  set tabstop=2
        au BufNewFile,BufRead *.tt set ft=html.css matchpairs-=<:>
        au BufNewFile,BufRead *.flavour set ft=yaml.flavour
        au BufNewFile,BufRead *.lancet set ft=dosini
        au BufNewFile,BufRead .babelrc set ft=javascript
        " That's so i have my css snippets in scss files
        au BufNewFile,BufRead *.scss set ft=scss.css
        au FileType scss,css nnoremap <buffer> <F5> :call CSScomb()<CR>
        " Reload snippets when editing snippets file
        au! BufWritePost *.snippet call ReloadAllSnippets()
        au! FileType javascript call DetectMinifiedJavaScriptFile()
        au BufRead,BufNewFile *.js call DetectMinifiedJavaScriptFile()
        au! FileType javascript call DetectJSX()
        au! BufRead,BufNewFile *.json set ft=json
        au! bufwritepost vimrc nested source $MYVIMRC
        au BufRead,BufWinEnter,WinEnter,FocusGained * checktime
    endif

    " Automatically reload file if it was changed on disc
    " and was saved already in the editor
    set autoread
"}}}

" Directories for swp files {{{
    set backupdir=~/.vim/backup
    set noswapfile
    set undofile
    set undodir=~/.vim/backup
"}}}

"""""" NEED TO CHECK IF ALL ARE STILL USED AND MOVE UP
" Plugins {{{
    " Unimpaired {{{
        " Bubble single lines
        nmap <D-k> [e
        nmap <D-j> ]e
        " Bubble multiple lines
        vmap <D-k> [egv
        vmap <D-j> ]egv
    "}}}
    " TComment {{{
        map <silent> // :TComment<CR>
    "}}}
    " ZoomWin configuration {{{
        map <Leader><Leader> :ZoomWin<CR>
        if has('nvim')
            " removed 'key', 'oft', 'sn', 'tx' options which do not work with nvim
            let g:zoomwin_localoptlist = ["ai","ar","bh","bin","bl","bomb","bt","cfu","ci","cin","cink","cino","cinw","cms","com","cpt","diff","efm","eol","ep","et","fenc","fex","ff","flp","fo","ft","gp","imi","ims","inde","inex","indk","inf","isk","kmp","lisp","mps","ml","ma","mod","nf","ofu","pi","qe","ro","sw","si","sts","spc","spf","spl","sua","swf","smc","syn","ts","tw","udf","wfh","wfw","wm"]
        endif
    "}}}
    " Fugitive {{{
        autocmd User fugitive
          \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
          \   nnoremap <buffer> .. :edit %:h<CR> |
          \ endif
        autocmd BufReadPost fugitive://* set bufhidden=delete
    "}}}
    " Gundo {{{
        nnoremap <Leader>gu :GundoToggle<CR>
    "}}}
    " Ale {{{
        let g:ale_linters = {
        \   'javascript': ['eslint'],
        \   'typescript': ['tsserver', 'tslint', 'eslint'],
        \   'scss': ['stylelint'],
        \}
        let g:ale_linters_explicit = 1
        let g:ale_set_signs = 0
        set signcolumn=no
    "}}}
    " IndentLine {{{
        let g:indentLine_char = '│'
        let g:indentLine_noConcealCursor = 1
    "}}}
    " Emmet {{{
        let g:user_emmet_leader_key='<C-e>'
    "}}}
    " CtrlP {{{
        " if file is already open, do not switch to it
        let g:ctrlp_switch_buffer = 'et'
        if executable("ag")
            let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
        endif

        " let g:ctrlp_custom_ignore = {
        "   \ 'dir':  '\v[\/](.git|.hg|.svn|.egg_link|.egg-info|.*migrations|env|cms-test-env|filer_public)$'
        "   \ }
        nnoremap <silent> <C-p> :CtrlP<CR>
    "}}}
    " Require navigator {{{
        nnoremap <Leader>gf :call Navigate()<cr>
        nnoremap <Leader>gb :call Back()<cr>
    "}}}
    " Supertab {{{
        let g:SuperTabDefaultCompletionType = "context"
        set completeopt-=preview
    "}}}
    " Airline {{{
        let g:airline_powerline_fonts = 0
        let g:airline#extensions#bufferline#enabled = 0
        let g:airline#extensions#branch#enabled = 1
        let g:airline#extensions#tagbar#enabled = 0
        let g:airline#extensions#csv#enabled = 0
        let g:airline#extensions#hunks#non_zero_only = 1
        let g:airline#extensions#virtualenv#enabled = 0
        let g:airline#extensions#eclim#enabled = 0
        let g:airline#extensions#tabline#enabled = 0
        let g:airline#extensions#tmuxline#enabled = 1
        let g:airline#extensions#nrrwrgn#enabled = 0
        let g:airline#extensions#ale#enabled = 1
        let g:airline#extensions#coc#enabled = 0

        let g:airline_skip_empty_sections = 1
        let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

        " let g:tmuxline_powerline_separators = 0
        let g:tmuxline_separators = {
            \ 'left' : ' ',
            \ 'left_alt': '',
            \ 'right' : '',
            \ 'right_alt' : ' ',
            \ 'space' : ' ' }
    "}}}
    " Tern {{{
        let g:tern_show_signature_in_pum = 1
    "}}}
    " Toggle Cursor {{{
        " upon hitting escape to change modes,
        " send successive move-left and move-right
        " commands to immediately redraw the cursor
        " inoremap <special> <Esc> <Esc>hl
        set ttimeoutlen=30

        if has('gui_running')
            set guicursor+=a:blinkon0
        else
            " don't blink the cursor
            set guicursor+=i:blinkwait0
        endif

        let g:togglecursor_disable_neovim = 1

        " use | instead of █ for insert mode
        if has('nvim')
            set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50
        endif
    "}}}
    " Expand region {{{
        vmap v <Plug>(expand_region_expand)
        vmap <C-v> <Plug>(expand_region_shrink)
    "}}}
    " Delimitmate {{{
        let delimitMate_matchpairs = "(:),[:],<:>"
    "}}}
    " EditorConfig {{{
        " let g:EditorConfig_core_mode = 'python_external'
    "}}}
    " Prettier {{{
        autocmd BufRead .prettierrc set ft=json
        " autocmd BufWritePre *.js Prettier
        " autocmd BufWritePre *.scss Prettier
        " autocmd BufWritePre *.ts Prettier
        " autocmd BufWritePre *.tsx Prettier
    "}}}
    " Typescript {{{
        autocmd FileType typescript setlocal completeopt+=menu,preview
    "}}}
    " COC {{{
        inoremap <silent><expr> <TAB>
            \ pumvisible() ? coc#_select_confirm() :
            \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()

        command! -nargs=0 Prettier :CocCommand prettier.formatFile
        let g:coc_filetype_map = {
            \ 'scss.css': 'scss'
            \ }

        " inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
        " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

        function! s:check_back_space() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        let g:coc_snippet_next = '<tab>'
        imap <C-e> <Plug>(coc-snippets-expand)

        nnoremap <silent> gh :call <SID>show_documentation()<CR>
        " gd - go to definition of word under cursor
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)

        " gi - go to implementation
        nmap <silent> gi <Plug>(coc-implementation)

        " gr - find references
        nmap <silent> gr <Plug>(coc-references)

        function! s:show_documentation()
            if &filetype == 'vim'
                execute 'h '.expand('<cword>')
            else
                call CocAction('doHover')
            endif
        endfunction

        autocmd CursorHold * silent call CocActionAsync('highlight')

        let b:coc_diagnostic_info = {'error': 1, 'warning': 1, 'info': 0, 'hint': 1}
    "}}}
    " Echodoc "{{{
        " set cmdheight=2
        set noshowmode
    "}}}
" }}}

" Debugging options {{{
    " Setting this below makes it sow that error messages don't disappear after one second on startup.
    "set debug=msg

    " The following beast is something i didn't write... it will return the
    " syntax highlighting group that the current `thing` under the cursor
    " belongs to -- very useful for figuring out what to change as far as
    " syntax highlighting goes.
    "nmap <silent> <Leader>qq :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
"}}}
