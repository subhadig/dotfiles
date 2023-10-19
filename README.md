# My Dotfiles
This repository contains my configuration files for different applications for
backing up and easily syncing between different devices.

## Usage
Clone this repository and follow the steps.
Replace `~/workspaces/personal/dotfiles` in all the steps with the actual
location of your *dotfiles* directory wherever applicable.

### bash
Place the following content in `.bashrc` before the `.bash_aliases` is sourced.

```bash
export DOTRCDIR="${HOME}/workspaces/personal/dotfiles"

# If the ~/workspaces/personal/dotfiles/bash/bashrc file exists then
# source it.
if [ -f ${DOTRCDIR}/bash/bashrc ]; then
    . ${DOTRCDIR}/bash/bashrc
fi
```

Append this to your existing `.bash_aliases`.
If the file does not exist, create one.

```bash
source $HOME/workspaces/personal/dotfiles/bash/bash_aliases
```

### neovim
Append this to the `$HOME/.config/nvim/init.vim`.
If the file does not exists, create one.

```bash
source $HOME/workspaces/personal/dotfiles/nvim/init.vim
```

To also configure the [vim-plugins](https://github.com/subhadig/vim-plugins),
execute the following commands:

```bash
mkdir -p ~/.local/share/nvim/site/pack/ && cd $_
git clone --recurse-submodules git@github.com:subhadig/vim-plugins.git
```

### vim
Append this to the existing `.vimrc`.
Create one if it does not exists.

```bash
source $HOME/workspaces/personal/dotfiles/vim/vimrc
```

### tmux
Append this to the existing `.tmux.conf`.
Create one if it does not exists.

```bash
source-file $HOME/workspaces/personal/dotfiles/tmux/tmux.conf
```

### ideavim
If using the ideavim plugin for IntelliJ Idea, create a file with name
`.ideavimrc` on your home directory and paste the following into it.

```vim
source ~/workspaces/personal/dotfiles/intellij/ideavimrc
```

## License
This repository and the files under it are licensed under the MIT license.
