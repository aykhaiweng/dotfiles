if !exists('g:vscode')
    set runtimepath+=~/.vim,~/.vim/after
    set packpath+=~/.vim
    source ~/.vimrc
    lua require('gitsigns-conf')
endif
