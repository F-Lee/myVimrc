" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" ===========================================================
" 环境设置
" ===========================================================
set nocompatible              " be iMproved, required
filetype off                  " required

set go=                      " 关闭GVIM菜单
autocmd GUIEnter * simalt ~x
set fileencodings=utf-8,gb2312,gbk,gb18030,big5  " 文件编码
set encoding=utf-8   " 文本编码
set guifont=Consolas:h13:b:cDEFAULT
source $VIMRUNTIME/delmenu.vim  " 菜单和右键菜单编码
source $VIMRUNTIME/menu.vim     " 菜单和右键菜单编码
set mouse=                      " 支持终端的右键菜单
"set pyxversion=3

" 现在vim8已经支持24bit真色彩
if has("termguicolors")
    set termguicolors
else
    set t_Co=256
endif

set fdm=indent                  " 启用indent折叠模式
set nofoldenable                " 先关闭折叠
nmap <C-E><C-E> zi

" 感谢jj
imap jj <esc>
imap kk <C-y>
imap <C-X><C-X> <C-X><C-O>
"inoremap " ""<ESC>i
"inoremap ( ()<ESC>i
"inoremap { {<CR>}<ESC>O<TAB>
nmap <F11> :bp<CR>
nmap <F12> :bn<CR>
nmap sn :noh<CR>
nmap <leader>ev :split $MYVIMRC<CR>    " 打开配置
noremap <leader>q :<C-U><C-R>=printf("cclose")<CR><CR>

syntax on                   " 自动语法高亮
set number                  " 显示行号
set rnu                     " 相对行号
set cursorline              " 突出显示当前行
set ruler                   " 打开状态栏标尺

set expandtab              " tab转空格，如果需要tab则先按ctrl+v再输入tab
set shiftwidth=4           " 设定 << 和 >> 命令移动时的宽度为 4
set softtabstop=4          " 使得按退格键时可以一次删掉 4 个空格
set tabstop=4              " 设定 tab 长度为 4

set tags+=./.tags;,.tags            " 导入索引文件
"set tags+=C:/Qt/Qt5.11.1/5.11.1/mingw53_32/tags    " Qt的头文件
"set tags+=/home/lifan/Qt/Qt5.12.12/5.12.12/android_arm64_v8a/tags
" modifyOtherKeys模式下需要识别转义
let &t_TI = ""
let &t_TE = ""

set autochdir                " 自动切换当前目录为当前文件所在的目录
set nobackup                " 覆盖文件时不备份
"set backupcopy = yes        " 设置备份时的行为为覆盖
set ignorecase smartcase    " 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感
"set nowrapscan              " 禁止在搜索到文件两端时重新搜索
"set incsearch               " 输入搜索内容时就显示搜索结果
"set hlsearch                " 搜索时高亮显示被找到的文本
"set noerrorbells            " 关闭错误信息响铃
"set novisualbell            " 关闭使用可视响铃代替呼叫

set laststatus=2            " 总是显示状态栏
"set clipboard+=unnamed
"set clipboard+=unnamedplus

set undodir=$HOME/.undodir
"let mapleader=","

"=====================================
"系统判定与环境变量
"=====================================
"-----------
"函数定义
"-----------
function! MySys()
    if has("win16") || has("win32") || has("win64") || has("win95")
        return "windows"
    elseif has("unix")
        return "linux"
    endif
endfunction

"--------------------------
"用户目录变量$VIMFILES
"--------------------------
if MySys() == "windows"
    let $VIMFILES = $VIM.'/vimfiles'
elseif MySys() == "linux"
    let $VIMFILES = $HOME.'/.vim'
endif

" ===========================================================
" 插件设置
" ===========================================================
" vim_plug插件管理器配置
call plug#begin('$VIMFILES/bundle/') " 开始并指定插件存放目录

" 主题颜色
Plug 'morhetz/gruvbox'
set rtp+=$VIMFILES/bundle/gruvbox
let g:gruvbox_invert_selection = 0
let g:gruvbox_italic = 1
let g:gruvbox_italicize_strings = 1
" let g:gruvbox_contrast_dark = 'soft'
colorscheme gruvbox
set background=dark

" c++的语法高亮
Plug 'octol/vim-cpp-enhanced-highlight'
let g:cpp_class_scope_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_no_function_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_member_variable_highlight = 1

" 增强状态栏
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#lsp#enabled = 1
"let g:airline#extensions#syntastic#enabled = 1
"let g:airline_theme = 'powerlineish'
let g:airline_theme = 'gruvbox'
let g:airline_powerline_fonts = 1   " 使用powerline打过补丁的字体
"set ambiwidth=double " 使用全角标点

" 自动生产tags
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project', '.pro', 'local_ver_build.sh']
let g:gutentags_ctags_tagfile = '.tags'
" 同时开启 ctags 和 gtags 支持：
let g:gutentags_modules = []
if executable('ctags')
    let g:gutentags_modules += ['ctags']
endif
" 注释的原因是因为我现在用leaderf
"if executable('gtags-cscope') && executable('gtags')
    "let g:gutentags_modules += ['gtags_cscope']
"endif
let s:vim_tags = expand('$HOME/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
"let g:Lf_CacheDirectory = expand('~')
"let g:gutentags_cache_dir = expand(g:Lf_CacheDirectory.'/.LfCache/gtags')
if !isdirectory(s:vim_tags) " 不存在则创建
   silent! call mkdir(s:vim_tags, 'p')
endif
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
let g:gutentags_ctags_exclude_wildignore = 1
let g:gutentags_ctags_exclude = ['node_modules']
" 禁用 gutentags 自动加载 gtags 数据库的行为,避免多项目加入干扰
"let g:gutentags_auto_add_gtags_cscope = 1
" 使gtags支持多语言,默认不配就是C/C++/JAVA等
"let $GTAGSLABEL = 'native-pygments'
"let $GTAGSCONF = '/usr/share/gtags/gtags.conf'
" 需要 pip3 install pygments  &&  pacman -S global

" 文件管理
Plug 'scrooloose/nerdtree'
let NERDTreeWinPos='left'
let NERDTreeWinSize=48
map <F9> :NERDTreeToggle<CR>
nmap ,t :NERDTreeFind<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
            \ quit | endif
" 文件管理相关插件
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'

" 自动补全括号
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsMapBS = 0 " 关掉删除时自动删一对

" 自动补全
if has('nvim')
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'             " vim8需要
    Plug 'roxma/vim-hug-neovim-rpc'    " vim8需要
endif
let g:deoplete#enable_at_startup = 1

" nvim-yarp要求python3的路径
if MySys() == "windows"
    let g:python3_host_prog='D:/Soft/Python38/python.exe'
endif

" deopleted的LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'lighttiger2505/deoplete-vim-lsp'
"Plug 'mattn/vim-lsp-settings'
let g:lsp_diagnostics_enabled = 0 "关闭lsp的警告检查
let g:lsp_document_code_action_signs_enabled = 0 " 关掉建议
let g:lsp_document_highlight_enabled = 1
nmap gr :LspReferences<CR>
nmap <leader>rn :LspRename<CR>

" c++LSP补全
if (executable('clangd'))
    augroup LspCPP
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
     \ 'name': 'clangd',
     \ 'cmd': {server_info->['clangd', '--compile-commands-dir=./build', '--clang-tidy', '--all-scopes-completion', '--log=verbose']},
     \ 'allowlist': ['c', 'cpp'],
     \ })
    augroup END
endif

" quickfix的快速预览，P关闭
Plug 'skywind3000/vim-preview'
autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>

" deoplete常用的补全插件
Plug 'Shougo/deoplete-clangx'
Plug 'Shougo/neoinclude.vim'
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}  " 需要先下载gocode命令:go get -u github.com/stamblerre/gocode, pip3 install --user pynvim
let g:deoplete#sources#go#gocode_binary = '$HOME/go/bin/gocode'
set completeopt-=preview
"autocmd CompleteDone * silent! pclose!

" python补全，需要先安装pip3 install --user jedi --upgrade
Plug 'deoplete-plugins/deoplete-jedi'
" python代码检查 pip3 install --user flake8 --upgrade   F7使用
Plug 'nvie/vim-flake8'

" js补全与语法检查
"Plug 'wokalski/autocomplete-flow' " js补全与语法检查
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' } " 使用全局的tern，需要在项目目录下有.tern-project
" 添加ternjs补全的文件类型
let g:deoplete#sources#ternjs#filetypes = [
                \ 'jsx',
                \ 'javascript.jsx',
                \ 'vue',
                \ 'html',
                \ 'htm',
                \ '...'
                \ ]
let g:deoplete#sources#ternjs#case_insensitive = 1 " 不区分大小写
let g:deoplete#sources#ternjs#depths = 1
let g:deoplete#sources#ternjs#types = 1

" 片段补全
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" html插件
Plug 'mattn/emmet-vim'
Plug 'othree/html5.vim'
Plug 'posva/vim-vue'
"Plug 'alvan/vim-closetag'

" 自动ds、cs、ys符号增删改
Plug 'tpope/vim-surround'

" CSS插件
Plug 'hail2u/vim-css3-syntax'
"Plug 'ap/vim-css-color'

" JavaScript支持插件
Plug 'pangloss/vim-javascript'
" 为jsdoc文档启用语法突出显示
let g:javascript_plugin_jsdoc = 1
" 为ngdoc启用额外语法突出显示
let g:javascript_plugin_ngdoc = 1
" 为Flow启用语法突出显示
let g:javascript_plugin_flow = 1

" 语法检查
Plug 'dense-analysis/ale'
Plug 'rhysd/vim-lsp-ale'
let g:ale_linters = {
            \    'c++': ['vim-lsp'],
            \    'c': ['vim-lsp']
            \}
let g:ale_fixers = ['clangtidy']
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_disable_lsp = 1 "关闭ale本身的lsp
let g:ale_floating_preview = 0 "是否以浮窗显示
let g:ale_set_highlights = 0
let g:ale_virtualtext_cursor = 1 "只有在光标移动到才显示详细信息
nmap <leader>sp <Plug>(ale_previous_wrap)
nmap <leader>sn <Plug>(ale_next_wrap)
nmap <leader>d <Plug>(ale_detail)

" 格式美化
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html', 'htm'] }
" <Leader>p 调用

" Go插件
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
let g:go_highlight_functions = 1
let g:go_highlight_functions_calls = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_imports_autosave = 1
" Go补全基础
Plug 'stamblerre/gocode', { 'rtp': 'vim', 'do': '~/.vim/bundle/gocode/vim/symlink.sh' }

" Git in vim
Plug 'tpope/vim-fugitive'
" 显示Git日志
Plug 'APZelos/blamer.nvim'
" let g:blamer_enabled = 1 "或者:BlamerToggle触发
let g:blamer_show_in_insert_modes = 0

" qt支持插件
Plug 'fedorenchik/qt-support.vim'

" 文件头跳转支持
Plug 'vim-scripts/a.vim'
map <F4> :A<CR>

" 书签显示
Plug 'kshenoy/vim-signature'

" 多行编辑
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" swp文件选项插件
Plug 'chrisbra/Recover.vim'

" 搜索增强
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
let g:Lf_ShortcutF = '<leader>ff'
let g:Lf_RootMarkers = ['.project', '.root', '.git', '.svn', '.pro', 'go.mod']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_ShowDevIcons = 1
let g:Lf_PopupWidth = 0.75
"set ambiwidth=double
let g:Lf_PreviewInPopup = 1
let g:Lf_WindowPosition = 'popup'
let g:Lf_PopupColorscheme = 'gruvbox_default'
let g:Lf_StlColorscheme= 'powerline'
"let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:Lf_WildIgnore = {
    \ 'dir': ['.svn', '.git', '.hg', 'node_modules', 'build-*', 'Web'],
    \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]','*.d']
    \ }
let g:Lf_GtagsAutoGenerate = 1
let g:Lf_Gtagslabel = 'native-pygments'
noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
noremap <leader>fs :<C-U><C-R>=printf("Leaderf self %s", "")<CR><CR>
noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fg :<C-U><C-R>=printf("Leaderf! gtags --by-context --auto-jump")<CR><CR>
noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
"noremap <C-P> :LeaderfLineAllCword<CR>
noremap <C-P> :<C-U><C-R>=printf("Leaderf --recall")<CR><CR>
noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg --heading -e %s ", expand("<cword>"))<CR><CR>
noremap <S-F> :<C-U><C-R>=printf("Leaderf! rg --heading -e ")<CR>
" CWord 就是指指针下的单词，和在命令行按下C-R C-W是一样的效果
" Leaderf gtags --update 手动创建符号数据库

" 注释支持
Plug 'preservim/nerdcommenter'

" 快速检索移动
Plug 'easymotion/vim-easymotion'
nmap ss <Plug>(easymotion-sn)
nmap s2 <Plug>(easymotion-s2)
let g:EasyMotion_add_search_history = 0 " 不添加到搜索，避免高亮

" Markdown 需要nodejs和yarn
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'godlygeek/tabular'        " 文本对齐
Plug 'preservim/vim-markdown'
let g:mkdp_browser = 'chromium'
let g:mkdp_theme = 'light'
nmap <C-F5> :MarkdownPreviewToggle<CR>

" 你的所有插件需要在下面这行之前
call plug#end()            " 必须
filetype plugin indent on    " 必须 打开文件类型检测，加载vim自带和插件相应的语法和文件类型相关脚本
" 忽视插件改变缩进,可以使用以下替代:
"filetype plugin on
"
" 简要帮助文档
" :PlugList       - 列出所有已配置的插件
" :PlugInstall    - 安装插件,追加 `!` 用以更新或使用 :PluginUpdate
" :PlugSearch foo - 搜索 foo ; 追加 `!` 清除本地缓存
" :PlugClean      - 清除未使用插件,需要确认; 追加 `!` 自动批准移除未使用插件

" 函数调用需要在plug#end()之后
call deoplete#custom#option('ignore_sources', {'cpp': ['around', 'buffer']})
"call deoplete#custom#option('ignore_sources', {'cpp': ['around', 'buffer', 'member']})
call deoplete#custom#source('_', 'smart_case', v:true)  " 所有源都支持智能大小写

" 生成tags
map <C-F8> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" 强制保存只读
cmap w!! w !sudo tee % > /dev/null

" :sus切换至后台 fg切回来

