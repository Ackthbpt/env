# Dotfiles

Personal shell, vim, and terminal configuration managed with a bare git repo.

## Reset (for testing or starting over)

```bash
rm -rf $HOME/.cfg
rm -f ~/.zshrc ~/.p10k.zsh ~/.vimrc ~/.dircolors
rm -rf ~/.oh-my-zsh-custom
rm -rf ~/.oh-my-zsh
rm -rf ~/.vim
```

## New machine setup

### 1. Install prerequisites

```bash
# Debian/Ubuntu:
sudo apt install zsh git curl vim

# macOS:
brew install git coreutils
```

### 2. Install oh-my-zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 3. Clone and restore dotfiles

```bash
git clone --bare https://github.com/Ackthbpt/env.git $HOME/.cfg
alias dotfiles="$(which git) --git-dir=$HOME/.cfg/ --work-tree=$HOME"
dotfiles config --local status.showUntrackedFiles no
dotfiles config pull.rebase false
dotfiles checkout 2>/dev/null
if [ $? -ne 0 ]; then
  dotfiles checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | \
    xargs -I{} mv {} {}.bak
  dotfiles checkout
fi
```

### 4. Install third-party zsh plugins and themes

These are not tracked in the repo and must be cloned on each machine. They go
into `~/.oh-my-zsh-custom/` which is set as `ZSH_CUSTOM` in `.zshrc`.

```bash
# powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  $HOME/.oh-my-zsh-custom/themes/powerlevel10k

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
  $HOME/.oh-my-zsh-custom/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  $HOME/.oh-my-zsh-custom/plugins/zsh-syntax-highlighting

# zsh-completions
git clone https://github.com/zsh-users/zsh-completions \
  $HOME/.oh-my-zsh-custom/plugins/zsh-completions

# autoupdate (auto-updates custom plugins)
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins \
  $HOME/.oh-my-zsh-custom/plugins/autoupdate
```

### 5. Install vim-plug and plugins

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall
```

### 6. Restart shell

```bash
exec zsh
```

## Pushing changes

Pulling uses HTTPS and works anywhere. Pushing requires an SSH key on each machine.

### One-time SSH key setup (per machine)

```bash
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub
```

Add the output to GitHub: **Settings → SSH and GPG keys → New SSH key**

Then set the push URL to SSH:

```bash
dotfiles remote set-url --push origin git@github.com:Ackthbpt/env.git
```

### Day-to-day usage

```bash
dotfiles status
dotfiles add ~/.zshrc
dotfiles commit -m "updated zsh aliases"
dotfiles push
```

## Switching to root

```bash
sudo -E -s
```

The `-E` flag preserves your environment (including `$HOME` and shell config) and
`-s` starts a shell. You'll get your full zsh setup with colors and prompt as root.

If your distro blocks `-E` (some lock this down in sudoers), fall back to `visudo`
and add:

```
Defaults:[YOUR_USERNAME_HERE]   env_keep += "HOME"
Defaults:[YOUR_USERNAME_HERE]   !always_set_home
```

There are security implications to this, so be aware when implementing.

## What's tracked vs. what's installed

**Tracked in this repo** (your personal config files):
- `.zshrc`, `.p10k.zsh`, `.vimrc`, `.dircolors`
- `.oh-my-zsh-custom/aliases.zsh`
- `.oh-my-zsh-custom/functions.zsh`
- `.oh-my-zsh-custom/macos.zsh`
- `.oh-my-zsh-custom/plugins/autoupdate/autoupdate.plugin.zsh`

**Not tracked** (installed by their own tools on each machine):
- oh-my-zsh
- powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions
- vim-plug and all vim plugins
- coreutils (macOS only, for `gdircolors` and `gls`)