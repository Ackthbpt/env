# These seem to be unique across operating systems
alias lla='ls -Al'
alias mountt='mount | column -t'
alias colortable='ruby -e "$(curl -fsSL https://raw.githubusercontent.com/gawin/bash-colors-256/master/colors)"'

# Set up OS-specific settings
case `uname` in
    Darwin)
		# macOS only - this is is to work around some OMZ odd behavior and force use of GNU ls
		alias ls='/opt/homebrew/bin/gls --color=tty'
        ;;
esac
