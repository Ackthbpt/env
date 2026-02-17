# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Because installing a submodule into another submodule just wasn't working
ZSH_CUSTOM="$HOME/.oh-my-zsh-custom"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=1

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(gnu-utils z git sudo zsh-autosuggestions colored-man-pages cp jsontools nmap rsync ssh-agent zsh-interactive-cd autoupdate extract zsh-syntax-highlighting docker systemd brew genpass ssh)

# oh_my_zsh autoupdate plugin - Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=1

# oh_my_zsh autoupdate plugin - turns off the "Upgrading custom plugins" prompt
ZSH_CUSTOM_AUTOUPDATE_QUIET=false

# For the "ssh-agent" plugin
zstyle :omz:plugins:ssh-agent agent-forwarding on
#zstyle :omz:lib:theme-and-appearance gnu-ls no

# Quit checking the permissions on the files/folders (makes 'sudo -s' noisy)
ZSH_DISABLE_COMPFIX=true

# This plugin isn't instantiated like normal ones are, according to the docs
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit -u

source $ZSH/oh-my-zsh.sh

eval "$(brew shellenv zsh)"

# User configuration
export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Specify the default editor
export EDITOR=vim

# LS colors are pretty
export LS_OPTIONS='--color=auto'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

# This is so I can keep all my dotfiles in $HOME without silly symlink
# shenanigans
alias dotfiles="$(which git) --git-dir=$HOME/.cfg/ --work-tree=$HOME"

# Set up OS-specific settings
case `uname` in
	Darwin)
		eval $(gdircolors -b $HOME/.dircolors)
		#source /opt/homebrew/opt/gitstatus/gitstatus.prompt.zsh
		# Activate TheFuck
		#eval $(thefuck --alias)
		;;
	Linux)
		eval $(dircolors -b ~/.dircolors)
		;;
esac

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Various variables
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
#GITSTATUS_LOG_LEVEL=DEBUG

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Turns on extended-sort mode by default.  Prefix search terms with ' for exact
# match
export FZF_DEFAULT_OPTS='--extended'
