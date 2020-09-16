# My Dotfiles
This repository contains my configuration files for different applications for
backing up and easily syncing between different devices.

## Usage
Clone this repository and follow the steps.
Replace `~/workspaces/personal/dotfiles` in all the steps with the actual
location of your *dotfiles* directory wherever applicable.

### bash
Append this to the existing .bashrc.

```bash
# If the ~/workspaces/personal/dotfiles/bash/bashrc file exists then
# source it.
if [ -f ~/workspaces/personal/dotfiles/bash/bashrc ]; then
    . ~/workspaces/personal/dotfiles/bash/bashrc
fi
```

Append this to your existing .bash_aliases. If the file does not exist, create
one.

```bash
source $HOME/workspaces/personal/dotfiles/bash/bash_aliases
```

### neovim
Append this to the existing init.vim. If the file does not exists, create one
under `$HOME/.config/nvim`

```bash
source $HOME/workspaces/personal/dotfiles/nvim/init.vim
```

### vim
Append this to the existing .vimrc. Create one if it does not exists.

```bash
source $HOME/workspaces/personal/dotfiles/vim/vimrc
```

### tmux
Append this to the existing .tmux.conf. Create one if it does not exists.

```bash
source-file $HOME/workspaces/personal/dotfiles/tmux/tmux.conf
```

## License
This repository is licensed under the MIT license.
