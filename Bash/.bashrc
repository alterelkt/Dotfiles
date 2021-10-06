#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export VISUAL=vim;
export EDITOR=vim;

RANGER_LOAD_DEFAULT_RC=FALSE

export ZDOTDIR="$HOME/.config/zsh"
export VIMINIT="source ~/.config/vim/vimrc"
