setopt autocd extendedglob nomatch 
setopt interactive_comments
stty stop undef
zle_highlight=('paste:none')
unsetopt BEEP
bindkey -v
# The following lines were added by compinstall
zstyle :compinstall filename '/home/aman/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -Uz colors && colors

source "$ZDOTDIR/zsh_functions"

zsh_add_file "zsh_aliases"
zsh_add_file "zsh_prompt"
zsh_add_file "zsh_exports"

zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
