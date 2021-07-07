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

"colorscheme atom-dark-256     " 主题
set go=                      " 关闭GVIM菜单
autocmd GUIEnter * simalt ~x
set fileencodings=utf-8,gb2312,gbk,gb18030,big5  " 文件编码
set encoding=utf-8   " 文本编码
set guifont=Consolas:h13:b:cDEFAULT
set t_Co=256
source $VIMRUNTIME/delmenu.vim  " 菜单和右键菜单编码
source $VIMRUNTIME/menu.vim     " 菜单和右键菜单编码
"set pyxversion=3

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

syntax on                   " 自动语法高亮
set number                  " 显示行号
set rnu                     " 相对行号
set cursorline             " 突出显示当前行
set ruler                   " 打开状态栏标尺

set expandtab               " tab转空格，如果需要tab则为ctrl+v
set shiftwidth=4           " 设定 << 和 >> 命令移动时的宽度为 4
set softtabstop=4          " 使得按退格键时可以一次删掉 4 个空格
set tabstop=4              " 设定 tab 长度为 4

set tags+=./tags;            " 导入索引文件
"set tags+=C:/Qt/Qt5.11.1/5.11.1/mingw53_32/tags    " Qt的头文件
"set tags+=/home/lifan/Qt5.12.2/5.12.2/gcc_64/tags
" modifyOtherKeys模式下需要识别转义
let &t_TI = ""
let &t_TE = ""

set autochdir                " 自动切换当前目录为当前文件所在的目录
set nobackup                " 覆盖文件时不备份
"set backupcopy = yes        " 设置备份时的行为为覆盖
"set ignorecase smartcase    " 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感
"set nowrapscan              " 禁止在搜索到文件两端时重新搜索
"set incsearch               " 输入搜索内容时就显示搜索结果
"set hlsearch                " 搜索时高亮显示被找到的文本
"set noerrorbells            " 关闭错误信息响铃
"set novisualbell            " 关闭使用可视响铃代替呼叫

set laststatus=2            " 总是显示状态栏

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
colorscheme gruvbox
set background=dark

" 增强状态栏
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
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
let g:gutentags_auto_add_gtags_cscope = 0
" 使gtags支持多语言,默认不配就是C/C++/JAVA等
"let $GTAGSLABEL = 'native-pygments'
"let $GTAGSCONF = '/usr/share/gtags/gtags.conf'

" 函数符号
Plug 'majutsushi/tagbar'
if MySys() == "windows"                " 设定windows系统中ctags程序的位置
    let g:tagbar_ctags_bin = '$VIMFILES/ctags/ctags.exe'
elseif MySys() == "linux"
    let g:tagbar_ctags_bin = '/usr/bin/ctags'
endif
"nmap <Leader>tb :TagbarToggle<CR>        "快捷键设置
"let g:tagbar_ctags_bin='ctags'            "ctags程序的路径
let g:tagbar_width=30                    "窗口宽度的设置
map <F10> :Tagbar<CR>
"autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx call tagbar#autoopen()     "如果是c语言的程序的话，tagbar自动开启

" 文件管理
Plug 'scrooloose/nerdtree'
let NERDTreeWinPos='left'
let NERDTreeWinSize=48
map <F9> :NERDTreeToggle<CR>
nmap ,t :NERDTreeFind<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
            \ quit | endif

Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'

" 标签管理
"Plug 'fholgado/minibufexpl.vim'
"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplModSelTarget = 1
"let g:miniBufExplMoreThanOne=0
"map <F11> :MBEbp<CR>
"map <F12> :MBEbn<CR>

" 自动补全括号
Plug 'jiangmiao/auto-pairs'

" 自动补全
"Plug 'Shougo/neocomplete.vim'
"let g:neocomplete#enable_at_startup = 1

" 自动补全2
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

" deopleted的补全插件
Plug 'Shougo/deoplete-clangx'
Plug 'Shougo/neoinclude.vim'
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}  " 需要先下载gocode命令:go get -u github.com/stamblerre/gocode, pip3 install --user pynvim
let g:deoplete#sources#go#gocode_binary = '$HOME/go/bin/gocode'
set completeopt-=preview
"autocmd CompleteDone * silent! pclose!

" python补全，需要先安装pip3 install --user jedi --upgrade
Plug 'deoplete-plugins/deoplete-jedi'

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
Plug 'ap/vim-css-color'

" JavaScript支持插件
Plug 'pangloss/vim-javascript'
" 为jsdoc文档启用语法突出显示
let g:javascript_plugin_jsdoc = 1
" 为ngdoc启用额外语法突出显示
let g:javascript_plugin_ngdoc = 1
" 为Flow启用语法突出显示
let g:javascript_plugin_flow = 1

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
if MySys() == "windows"
    Plug 'Yggdroot/LeaderF', { 'do': '\install.bat' }
elseif MySys() == "linux"
    Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
endif
"Plug 'Yggdroot/LeaderF', { 'do': 'LeaderfInstallCExtension' }
let g:Lf_ShortcutF = '<leader>ff'
let g:Lf_RootMarkers = ['.project', '.root', '.git', '.svn', '.pro', 'go.mod']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_ShowDevIcons = 0
let g:Lf_StlColorscheme= 'powerline'
"let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:Lf_WildIgnore = {
    \ 'dir': ['.svn', '.git', '.hg', 'node_modules'],
    \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
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
noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
noremap <C-P> :LeaderfLineAllCword<CR>
noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
" CWord 就是指指针下的单词，和在命令行按下C-R C-W是一样的效果

" 注释支持
Plug 'preservim/nerdcommenter'

" 你的所有插件需要在下面这行之前
call plug#end()            " 必须
filetype plugin indent on    " 必须 加载vim自带和插件相应的语法和文件类型相关脚本
" 忽视插件改变缩进,可以使用以下替代:
"filetype plugin on
"
" 简要帮助文档
" :PlugList       - 列出所有已配置的插件
" :PlugInstall    - 安装插件,追加 `!` 用以更新或使用 :PluginUpdate
" :PlugSearch foo - 搜索 foo ; 追加 `!` 清除本地缓存
" :PlugClean      - 清除未使用插件,需要确认; 追加 `!` 自动批准移除未使用插件

" 生成tags
map <C-F8> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" 强制保存只读
cmap w!! w !sudo tee % > /dev/null

" :sus切换至后台

