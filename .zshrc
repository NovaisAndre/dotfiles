# set -o vi
# bindkey -v


if [[ -t 0 ]]; then
  stty -ixon
fi
# Enable Powerlevel10k instant prompt. 
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set Zinit directory and load Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if not already installed
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Plugins and Snippets
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Snippets from Oh My Zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# Load Powerlevel10k prompt configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -s ^x "/home/$USER/.scripts/tmux-sessionizer.sh\n"
bindkey -s ^p "/home/$USER/.scripts/search-zsh.sh\n"
#bindkey '^[w' kill-region

# History settings
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias mkdir="mkdir -pv"
alias cd='z'
alias cut_paper="echo -ne '\x1D\x56\x01' >> /dev/usb/lp0"
alias android='sh /usr/local/android-studio/bin/studio.sh'
alias oil='~/dotfiles/.scripts/oil-ssh.sh'

# Environment Variables
export PATH="$PATH:$HOME/work/flutter/bin"
export PATH="$PATH:$HOME/personal/projects/dwm/statusbar"
export PATH="/usr/local/texlive/2024/bin/x86_64-linux:$PATH"
export EDITOR="nvim"
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export PATH=~/.npm-global/bin:$PATH
export PKG_CONFIG_PATH=/path/to/lib/pkgconfig:$PKG_CONFIG_PATH
#export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.cargo/env"

# Open current command in editor with Ctrl+x e
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Initialize zoxide
eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/$USER/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
alias protontricks='flatpak run com.github.Matoking.protontricks'
alias protontricks-launch='flatpak run --command=protontricks-launch com.github.Matoking.protontricks'


# opencode
export PATH="/home/$USER/.opencode/bin:$PATH"

# Delete word good stuff
## Controlled delete (small chunks)
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

backward-kill-small-word() {
  emulate -L zsh
  WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
  zle backward-kill-word
}
zle -N backward-kill-small-word

## Big delete widget
backward-kill-big-word() {
  emulate -L zsh
  WORDCHARS='*?_-[]~=&;!#$%^(){}<>./:'
  zle backward-kill-word
}
zle -N backward-kill-big-word

bindkey '^[w' backward-kill-big-word     # Alt+W → big delete
bindkey '^W'  backward-kill-small-word   # Ctrl+W  → controlled delete

# Path to your sound file
FAHHH="$HOME/.sounds/fahhh.mp3"
BOCCHI_LAUGH="$HOME/Music/.sounds/bocchi-laugh.mp3"

play_error_sound() {
  local exit_code=$?
  if [[ $exit_code -ne 0 && $exit_code -ne 130 ]]; then
    mpv --no-terminal --really-quiet "$FAHHH" >/dev/null 2>&1 &!
  fi
}




# opencode
export PATH=/home/husky/.opencode/bin:$PATH

. "$HOME/.local/bin/env"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/husky/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/husky/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/husky/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/husky/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

