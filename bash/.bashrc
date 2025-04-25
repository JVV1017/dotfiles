#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

########################################################################
########################################################################
####
####                   ARCH
####
########################################################################
########################################################################

# COMMAND BASED ALIASES
#alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

########################################################################
########################################################################
####
####                   CACHYOS
####
########################################################################
########################################################################

# COMMAND BASED ALIASES
alias ls='eza -l --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='eza -al --color=always --group-directories-first --icons'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | grep -e '^\.'"                                     # show only dotfiles

# BEGINNER FRIENDLY
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'                                   # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"              # Sort installed packages according to size in MB
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'          # List amount of -git packages
alias update='sudo pacman -Syu'

# Help people new to Arch
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'
alias tb='nc termbin.com 9999'

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

########################################################################
########################################################################
####
####                   MY ALIASES
####
########################################################################
########################################################################

# COMMAND BASED ALIASES
alias vim='nvim'
alias cat='bat'
alias rm='trash-put'
alias cal='cal --monday' 
alias birthdate='stat / | grep 'Birth' | sed "s/Birth: //g" | cut -b 2-11'
alias speedtest='~/Downloads/ookla-speedtest-1.2.0-linux-x86_64/speedtest'
alias df='duf -only local'
alias Git='cd ~/Git/'
alias Downloads='cd ~/Downloads/'
alias Documents='cd ~/Documents/'
alias Pictures='cd ~/Pictures/'
alias Videos='cd ~/Videos/'
alias Music='cd ~/Music/'
alias Important='cd ~/Documents/Important/'
alias Sem6='cd ~/Documents/Important/BCS/Year3/Sem2/'
alias system-update='sudo pacman -Syu && yay -Syu && flatpak update'
alias cache='sudo pacman -Scc && yay -Scc' 
alias ff='fastfetch' 
alias weather='curl wttr.in'
alias freemem='free -mh'
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BATT' 
alias feh='feh --scale-down'
alias starship-update='curl -sS https://starship.rs/install.sh | sh'
alias process-count='ps aux | wc -l'
alias mirrors='sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'

# SCRIPT BASED ALIASES 
alias metadata-update='~/Documents/scripts/update_metadata.sh'

# FUNCTION BASED ALIASES
function yays() {
    yay -Slq | fzf -q "$1" -m --preview 'yay -Si {1}'| xargs -ro yay -S
}

########################################################################
########################################################################
####
####                   CONFIGS
####
########################################################################
########################################################################

# Starship Prompt
eval "$(starship init bash)"

# Broot (tree alternative)
source ~/.config/broot/launcher/bash/br

# Mcfly
# eval "$(mcfly init bash)"
# export MCFLY_LIGHT=FALSE
# export MCFLY_KEY_SCHEME=vim
# export MCFLY_FUZZY=2
# export MCFLY_RESULTS=50
# export MCFLY_INTERFACE_VIEW=TOP
# export MCFLY_DISABLE_MENU=FALSE
# export MCFLY_PROMPT="❯"

# REVERSE SEARCH (FZF EDITION)
if command -v fzf &>/dev/null; then
  __fzf_reverse_search() {
    local selected
    # Use 'tac' to reverse history (or 'tail -r' on macOS)
    selected=$(
      history | tac | awk '!a[$0]++' | \
      sed 's/^[ ]*[0-9]*[ ]*//' | \
      fzf --tac --no-sort --reverse \
          --height 40% --border \
          --preview 'echo {}' \
          --preview-window down:3:wrap \
          --bind '?:toggle-preview'
    )
    # Put the selected command into the shell
    if [[ -n "$selected" ]]; then
      READLINE_LINE="$selected"
      READLINE_POINT=${#selected}
    fi
  }
  # Bind to Ctrl+R
  bind -x '"\C-r": __fzf_reverse_search'
fi

# RANDOM COLOR SCRIPT BY DISTRO TUBE (DT)
colorscript -e 12

########################################################################
########################################################################
####
####                   THEMES
####
########################################################################
########################################################################

# FZF Theme = CATPPUCCIN MOCHA
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--color=border:#313244,label:#cdd6f4"

#### QT THEMING VARIABLES
export QT_QPA_PLATFORMTHEME="kvantum"
export QT_QPA_PLATFORMTHEME="qt6ct"

#### LOCALE
export LANG=en_CA.UTF-8
export LC_ALL=en_CA.UTF-8
