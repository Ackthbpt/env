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

# fzf-enhanced history command - once you get used to this you can't go back
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

# Quick and dirty way to see where the hell an alias might be defined.  Noisy
# and far from perfect.
whichwhere() {
	PS4='+%x:%I >>> ' zsh -i -x -c '' |& grep -v zcompdump |& grep -i $1
}

#### 
# Docker functions
####

# Attach to a running docker container
function datt() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && echo "Attaching to $cid" && docker attach "$cid"
}

# Don't just attach, but drop you into the container's running shell (if it's
# running one)
function dockershell() {
    local container shell_cmd

  # Step 1: Use fzf to select a running container
  container=$(docker ps --format '{{.ID}} {{.Names}}' | fzf --prompt="Select container: " | awk '{print $1}')
  [[ -z "$container" ]] && echo "No container selected." && return 1

  # Step 2: Parse /etc/shells inside the container to find available shells
  shell_cmd=$(docker exec "$container" sh -c '
  if [ -f /etc/shells ]; then
      grep -E "/(zsh|bash|sh)$" /etc/shells | grep -E "/zsh$" && exit 0
      grep -E "/(bash|sh)$" /etc/shells | grep -E "/bash$" && exit 0
      grep -E "/sh$" /etc/shells && exit 0
  fi
  # Fallback in case /etc/shells is missing
  for s in /bin/zsh /usr/bin/zsh /bin/bash /usr/bin/bash /bin/sh; do
      [ -x "$s" ] && echo "$s" && break
  done
  ' 2>/dev/null | head -n 1)

  if [[ -z "$shell_cmd" ]]; then
    echo "❌o No usable shell found in container $container"
    return 1
  fi

  # Step 3: Attach to the container using the selected shell
  echo "🔗  Attaching to $container using $shell_cmd..."
  docker exec -it "$container" "$shell_cmd"
}

# Select a running docker container to rebuild                                  
function dcub() {                                                               
  local cid                                                                        
  cid=$(docker ps -a --format "{{.Names}}" | fzf -q "$1" | awk '{print $1}')    
                                                                                
  [ -n "$cid" ] && docker-compose up --force-recreate --build -d --remove-orphans "$cid"
}                                                                               

# Select a running docker container to rebuild AND tail the log
function dcubt() {                                                              
  local cid                                                                     
  cid=$(docker ps -a --format "{{.Names}}" | fzf -q "$1" | awk '{print $1}')    
                                                                                
  [ -n "$cid" ] && docker-compose -f ~/docker-compose.yml up --force-recreate --build -d --remove-orphans "$cid" && docker-compose logs -f "$cid"
}                                                                               

# Only create this alias if I'm on an Arch system
# And yes, I know I should use pacman instead of yay.  Whatever.
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
	OS=$NAME
	if [ $OS = "Arch Linux" ]; then
		alias yay-installed="yay -Qq | fzf --multi --preview 'yay -Qi {1}'"
	fi	
fi
