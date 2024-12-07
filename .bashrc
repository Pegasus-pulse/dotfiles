# ==========================================================================
#
#	██████╗ ███████╗ ██████╗  █████╗ ███████╗██╗   ██╗███████╗
#	██╔══██╗██╔════╝██╔════╝ ██╔══██╗██╔════╝██║   ██║██╔════╝
#	██████╔╝█████╗  ██║  ███╗███████║███████╗██║   ██║███████╗
#	██╔═══╝ ██╔══╝  ██║   ██║██╔══██║╚════██║██║   ██║╚════██║
#	██║     ███████╗╚██████╔╝██║  ██║███████║╚██████╔╝███████║
#	╚═╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝
#
# ==========================================================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


if [ -f /usr/bin/fastfetch ]; then
	fastfetch 
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s checkwinsize
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%F %T "

# Set the default editor
export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"

#######################################################################
# Aliases

# Alias's to modified commands
alias vim='nvim'
alias search='apt search'
alias install='sudo apt install'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
alias dist-upgrade='sudo apt dist-upgrade'
alias uplist='apt list --upgradable'
alias remove='sudo apt autoremove'
alias purge='sudo apt purge'
alias cat='batcat'

# Change directory aliases
alias ..='cd ..' 
alias ...='cd ../..'
alias home='cd ~'
alias root='cd /'

# Search command line history
alias h="history | grep "

# Mount .iso files
alias isomount='sudo mount -o loop'

# Start v2ray connection
alias startv2ray='sudo systemctl start v2raya.service'
alias stopv2ray='sudo systemctl stop v2raya.service'

# Alias's for modified directory listing commands
alias l='eza -ll --color=always --group-directories-first'
alias ls='eza -al --header --icons --group-directories-first'

# IP address lookup aliase
alias myip="ip -f inet address | grep inet | grep -v 'lo$' | cut -d ' ' -f 6,13 && curl ifconfig.me && echo ' external ip'"

# Alias's for archives
alias zp='7z a -t7z -mx=9'
alias uz='7z x'

# Unixporn
alias ff='fastfetch'
alias ascii='ascii-image-converter'
alias fortune='fortune | cowsay -f snowman | lolcat'

# Uncategorized aliases
alias diskhealth='sudo gsmartcontrol'
alias x='exit'

#######################################################################

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set the beautiful prompt
eval "$(starship init bash)"
