set shellslash " windowsでもパスの区切り判定に/を使える

"---- vimprocを自動ダウンロード・ビルドするオプション
"---- 何かのプロセスがvimprocを使うよりも前に書く必要がある
let g:vimproc#download_windows_dll=1

"======================================
" プラグインの設定
"======================================

"--------------------------------------
" Shougo/dein.vim
"--------------------------------------
if &compatible
  set nocompatible
endif
"---- dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif
"---- 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  let s:config_home = empty($XDG_CONFIG_HOME) ? expand('$VIM/.config/nvim') : $XDG_CONFIG_HOME . '/nvim'
  call dein#load_toml(s:config_home . '/dein.toml',      {'lazy':0})
  call dein#load_toml(s:config_home . '/dein_lazy.toml', {'lazy':1})
  call dein#end()
  call dein#save_state()
endif
"---- 未インストールのものがあったらインストール
if dein#check_install()
  call dein#install()
endif

"--------------------------------------
" itchyny/lightline.vim
"--------------------------------------
" ステータスラインをカスタマイズするプラグイン
" solarlizedに適した配色にする
let g:lightline = {
  \ 'colorscheme' : 'solarized',
  \ }
set noshowmode " --INSERT-- とかを非表示

"--------------------------------------
" vim-quickrun
"--------------------------------------
let g:quickrun_config={
  \ "hook/output_encode/enable" : 1,
  \ "hook/output_encode/encoding" : "utf-8",
  \ "hook/output_encode/fileformat" : "dos",
  \ }

"--------------------------------------
" osyo-manga/vim-watchdogs
"--------------------------------------
" この関数に g:quickrun_config を渡す
" この関数で g:quickrun_config にシンタックスチェックを行うための設定を追加する
" 関数を呼び出すタイミングはユーザの g:quickrun_config 設定後
call watchdogs#setup(g:quickrun_config)

"======================================
" 基本設定
"======================================

"--------------------------------------
" キーバインド
"--------------------------------------
nnoremap + <C-a> " Normalで数字をインクリメント
nnoremap - <C-x> " Normalで数字をデクリメント
" ターミナルモードでinsertからnormalへ
tnoremap <ESC> <C-\><C-n>
" ウィンドウ
nnoremap s <NOP> " sキーは潰す
nnoremap ss :<C-u>sp<CR> " :split
nnoremap sv :<C-u>vs<CR> " :vslplit
nnoremap sh <C-w>h " 左へ移動
nnoremap sj <C-w>j " 下へ移動
nnoremap sk <C-w>k " 上へ移動
nnoremap sl <C-w>l " 右へ移動
nnoremap sx <C-w>x " 次のウィンドウと入れ替え

"--------------------------------------
" カラースキーム
"--------------------------------------
set t_Co=256
set background=light
"set termguicolors " NeoSolarizedに必要らしいけど無くても動く、Why...
set background=light
colorscheme NeoSolarized

"--------------------------------------
" 文字コード
"--------------------------------------
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,sjis
set fileformats=dos

"--------------------------------------
" ファイル編集
"--------------------------------------
set autoread " 編集中のファイルが変更されたら自動で読み直す
set hidden   " バッファが編集中でもその他のファイルを開けるように
" 編集中にファイルタイプが変更されたとき、適したプラグインとインデントに変更する
filetype plugin indent on

" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start

"--------------------------------------
" ファイルの自動生成
"--------------------------------------
set nobackup   " バックアップファイルを作らない
set noswapfile " スワップファイルを作らない
set noundofile " アンドゥファイルを作らない


"--------------------------------------
" 括弧・タグジャンプ
"--------------------------------------
set matchpairs& matchpairs+=<:> " 対応括弧に<と>のペアを追加
set noshowmatch " 対応する括弧を強調表示
"set matchtime=1 " 閉じ括弧を入力したときに、開き括弧に飛ぶ時間 0.x秒
source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する
let loaded_matchparen = 1

"--------------------------------------
" インデント
"--------------------------------------
set autoindent  " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set tabstop=2     " ファイル内の<TAB>が対応する空白の数
set noexpandtab    " ソフトタブを無効にする
"set softtabstop=2 " <TAB>を押した際に挿入される空白の数
set shiftwidth=2  " (自動)インデントの各段階に使われる空白の数

"--------------------------------------
" コマンド補完
"--------------------------------------
set wildmenu     " コマンドモードの補完
set history=2000 " コマンド履歴の数
set showcmd      " 入力中のコマンドをステータスに表示する

"--------------------------------------
" 検索
"--------------------------------------
set incsearch  " /を打った後の文字を検索
set hlsearch   " 検索結果をハイライト
set ignorecase " 大文字小文字を区別しないで検索
set smartcase  " set ignorecaseと組み合わせて使うと小文字で検索したとき区別しない
set wrapscan   " 最後まで検索すると折り返して検索
" ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

"--------------------------------------
" 表示・非表示
"--------------------------------------
set ruler  " 現在のカーソル位置(行、桁)を Vim ウィンドウの右下に常に表示
set number " 行番号を表示
set title  " タイトルを表示
set list  " 不可視文字を表示
set listchars=tab:>-,extends:< " 不可視文字を表示
set cursorline " カーソルラインをハイライト

"--------------------------------------
" その他
"--------------------------------------
set laststatus=2 " 常にステータス行を表示 (詳細は:he laststatus)
set cmdheight=2  " コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set wrap     " 画面の端で文字列を折り返し
set whichwrap=b,s,h,l,<,>,[,],~ " カーソルの左右移動で行末から次の行の行頭への移動
set scrolloff=5 " スクロールするとき、下が見える
set helplang=ja,en " Vimヘルプを日本語化
set ambiwidth=double " □や○文字が崩れる問題を解決
set clipboard=unnamed " ヤンクでクリップボードにアクセス
