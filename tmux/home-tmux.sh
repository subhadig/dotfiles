#!/bin/bash

editor='nvim'

tmux -u new-session -d -s "dev" -n "notes" -c ~/workspaces/personal/notes $editor
tmux -u new-window -c ~/workspaces/personal -n "workspace"
tmux -u attach-session -d -c "~"
