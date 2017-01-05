set nocompatible              " be iMproved, required
set shell=/bin/sh
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()


" The theme, first
 Plugin 'buztard/vim-marshmallow'
 Plugin 'scrooloose/nerdtree'
 Plugin 'VHDL-indent-93-syntax'  
call vundle#end()

filetype plugin indent on     " Required!


set number
syntax on
map <F2> :NERDTreeToggle<CR>
