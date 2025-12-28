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
*) return ;;
esac

#if [ -f /usr/bin/fastfetch ]; then
#	fastfetch
#fi

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
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias vi='nvim'
alias search='apt search'
alias install='sudo apt install --no-install-recommends'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade --no-install-recommends'
alias d-upgrade='sudo apt dist-upgrade --no-install-recommends'
alias uplist='apt list --upgradable'
alias remove='sudo apt autoremove'
alias purge='sudo apt purge'
alias cat='batcat'

# Git
gcom() {
  git commit -m "$1"
}

lazyg() {
  git add .
  git commit -m "$1"
  git push
}

alias gpush='git push'

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

# Start windows file sharing
alias smbstart='sudo systemctl start smbd.service nmbd.service'
alias smbstop='sudo systemctl stop smbd.service nmbd.service'
alias smbstats='sudo systemctl status smbd.service nmbd.service'

# Alias's for modified directory listing commands
alias l='eza -ll --color=always --group-directories-first'
alias ls='eza -al --header --icons --group-directories-first'

# IP address lookup aliase
alias myip="ip -f inet address | grep inet | grep -v 'lo$' | cut -d ' ' -f 6,13 && curl ifconfig.me && echo ' external ip'"

# Alias's for archives
alias zp='7z a -t7z -mx=9'
alias uz='7z x'
alias ut='tar -xvf'

# Unixporn
alias ff='fastfetch'
alias ascii='ascii-image-converter'
alias fact='fortune | cowsay -f snowman | lolcat'

# Uncategorized aliases
alias diskhealth='sudo gsmartcontrol'
alias sysinfo='inxi -b'
alias x='exit'

#######################################################################
# Special Functions

# Automatically do an ls after each cd, z, or zoxide
cd() {
  z "$@" && l
}

# Copy file with a progress bar
cpp() {
  set -e
  strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
            printf "]\r"
        }
    }
    END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Goes up a specified number of directories  (i.e. up 4)
up() {
  local d=""
  limit=$1
  for ((i = 1; i <= limit; i++)); do
    d=$d/..
  done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

#######################################################################

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

eval "$(starship init bash)"
eval "$(zoxide init --cmd z bash)"
