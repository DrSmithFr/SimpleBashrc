##############################################################
########################## Colors ############################
##############################################################

# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Orange='\e[38;5;166m'   # Orange
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BOrange='\e[38;5;166m'  # Orange
BGreen='\e[1;32m'       # Green
BYellow="\e[1;33m"      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\[\e[45m'    # Purple
On_Cyan="\e[46m"        # Cyan
On_White="\e[47m"       # White

NC="\e[m"               # Color Reset

ALERT="${BWhite}${On_Red}" # Bold White on red background

##############################################################
#################### global configuration ####################
##############################################################

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify

# Fix keyboard input sometimes blocked when IBus is active
export IBUS_ENABLE_SYNC_MODE=1

##############################################################
########################## Aliases ###########################
##############################################################

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias h='history'
alias c='clear'
alias r='reset'
alias t='time'
alias rt='reset && time'
alias rl="r && l"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

alias d="docker"
alias dc="docker-compose"

alias apt-get='sudo apt-get'
alias aptitude='sudo aptitude'

# Git related
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gd='git diff'
alias gb='git branch'
alias gl='git log'
alias gsb='git show-branch'
alias gco='git checkout'
alias gg='git grep'
alias gk='gitk --all'
alias gr='git rebase'
alias gri='git rebase --interactive'
alias gcp='git cherry-pick'
alias grm='git rm'

## this assumes you use a recent GNU ls
export LS_OPTIONS='-h --color -l --group-directories-first'
alias ls="ls $LS_OPTIONS"

# Add colors for file type, human-readable sizes and human-readable rights by default on 'ls':
alias l="ls $LS_OPTIONS -v | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print \$0}'"
alias la="ls $LS_OPTIONS -v -A | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print \$0}'"

# Ls only for directory
alias ld="ls $LS_OPTIONS -d */ | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print \$0}'"
alias lda="ls $LS_OPTIONS -ad */ | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print \$0}'"

# Ls only for files
alias lf="ls $LS_OPTIONS | egrep -v '^d' | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print \$0}'"
alias lfa="ls $LS_OPTIONS -a | egrep -v '^d' | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print \$0}'"

##############################################################
####################### functions ############################
##############################################################

function ap()
{
    apt-get -y update &&
    apt-get -y upgrade &&
    apt-get -y dist-upgrade &&
    apt-get -y autoclean &&
    apt-get -y clean &&
    apt-get -y autoremove
}

function sudo()
{
    command="$@"
    if [[ -z "$command" ]]; then
        command sudo -s
    else
        command sudo "$@"
    fi
}

function docker_cleanup()
{
    sudo rm -rf /var/lib/docker/* && \
    docker rmi $(docker images -a --filter=dangling=true -q) && \
    docker rm $(docker ps --filter=status=exited --filter=status=created -q)
}

##############################################################
######################### Prompt #############################
##############################################################

export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch GIT_PS1_SHOWCOLORHINTS=1

if [[ "$(id -u)" = 0 ]]
then
    ## root users
    PS1="\[${ALERT}\]┌─"
    PS1+="\[${BBlack}\][\t] "
    PS1+="\[${BYellow}\]\u\[${NC}\]\[${ALERT}\]@\h "
    PS1+="(\[${BGreen}\]\w\[${NC}\]\[${ALERT}\])"

        # git display
        PS1+='$(__git_ps1 " '
        PS1+="[\[${BYellow}\]%s\[${NC}\]\[${ALERT}\]]"
        PS1+='") '
        PS1+=""

    PS1+="──┤\[${NC}\]\n"
    PS1+="\[${ALERT}\]└┤\\$├─►\[${NC}\] "
else
    ## common users
    PS1="\[${BRed}\]┌─\[${NC}\]"
    PS1+="[\t] "
    PS1+="\[${BRed}\]\u\[${NC}\]@\[${NC}\]\h\[${NC}\] "
    PS1+="(\[${BOrange}\]\w\[${NC}\])"

        # git display
        PS1+='$(__git_ps1 " '
        PS1+="[\[${BYellow}\]%s\[${NC}\]]"
        PS1+='") '

    PS1+="\[${BRed}\]──┤\n\[${BRed}\]└┤\[${NC}\]\\$\[${BRed}\]├─►\[${NC}\] "
fi

##############################################################
###################### Path config ###########################
##############################################################

if [[ "$UID" -eq 0 ]]; then
    PATH="$PATH:/usr/local/sbin"
    PATH="$PATH:/usr/local/bin"
    PATH="$PATH:/usr/local"
    PATH="$PATH:/usr/sbin"
    PATH="$PATH:/usr/bin"
    PATH="$PATH:/sbin"
    PATH="$PATH:/bin"
fi

# remove duplicate path entries
export PATH=$(echo $PATH | awk -F: '
{ for (i = 1; i <= NF; i++) arr[$i]; }
END { for (i in arr) printf "%s:" , i; printf "\n"; } ')
