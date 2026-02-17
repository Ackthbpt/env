# #!/bin/zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

which fzf &> /dev/null
if [ $? -eq 0 ]; then
else
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --no-fish --key-bindings --completion --no-update-rc
fi

# fzf and ripgrep-all is damned-near Turing complete
rf() {
    RG_PREFIX="rga --files-with-matches"
    local file
    file="$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
            fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                --phony -q "$1" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window="70%:wrap"
    )" &&
    echo "opening $file" &&
    open "$file"
}

# fzf-enhanced history command
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s -e -i --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# fzf-enhanced kill - kill processes, list only the ones you can kill.
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

# Quick and dirty way to see where the hell an alias might be defined.  Noisy.
whichwhere() {
	PS4='+%x:%I >>> ' zsh -i -x -c '' |& grep -v zcompdump |& grep -i $1
}

# #Docker functions
# Docker attach
function datt() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && echo "Attaching to $cid" && docker attach "$cid"
}

# Select a running docker container to stop
function dres() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker restart "$cid"
}

# Only create this alias if I'm on an Arch system
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
	OS=$NAME
	if [ $OS = "Arch Linux" ]; then
		alias yay-installed="yay -Qq | fzf --multi --preview 'yay -Qi {1}'"
	fi	
fi
