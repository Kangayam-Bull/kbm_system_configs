# Neovim:

## [Windows]
Installation location: "C:\Program Files\Neovim\bin\nvim.exe"
config location: "C:\Users\bmuru\AppData\Local\nvim\init.vim"

plugin manager: vimplug (https://github.com/junegunn/vim-plug) -> follow the instructions

plugin info in the config file should be placed as shown below:
"-------Unix-----------
"call plug#begin('~/.vim/plugged')
"------Windows---------
call plug#begin('~/AppData/Local/nvim/plugged')
"all the links to download the plugins go here between the begin and end tag.
call plug#end()
"for more info refer to the example init.vim

After adding in the plugin's source in the init.vim, open the nvim and run :PlugInstall command to install the plugins
Documentations for each plugin has to be derived from the sources(git sources)
If you want to uninstall certain plugin remove the same from the init.vim and then run :PlugClean

Example: https://sharksforarms.dev/posts/neovim-rust/
rust-analyzer:
Install with instruction from https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary


