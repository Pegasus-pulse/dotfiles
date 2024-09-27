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

# Aliases
alias vim='nvim'
alias ..='cd ..' 
alias ...='cd ../..'
alias home='cd ~'
alias root='cd /'
alias search='apt search'
alias install='sudo apt install'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
alias dist-upgrade='sudo apt dist-upgrade'
alias uplist='apt list --upgradable'
alias remove='sudo apt autoremove'
alias purge='sudo apt purge'
alias isomount='sudo mount -o loop'
alias startv2ray='sudo systemctl start v2raya.service'
alias stopv2ray='sudo systemctl stop v2raya.service'
alias ff='fastfetch'
alias diskhealth='sudo gsmartcontrol'
alias cat='batcat'
alias l='eza -ll --color=always --group-directories-first'
alias ls='eza -al --header --icons --group-directories-first'
alias ascii='ascii-image-converter'
alias fortune='fortune | cowsay -f snowman | lolcat'
alias myip="ip -f inet address | grep inet | grep -v 'lo$' | cut -d ' ' -f 6,13 && curl ifconfig.me && echo ' external ip'"
alias x='exit'

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set the beautiful prompt
eval "$(starship init bash)"

