#!/bin/bash

editor='nvim'

tmux new-session -d -s "dev" -n "notes" -c ~/workspaces/personal/notes $editor
tmux new-window -c ~/"OneDrive - Pegasystems Inc"/notes/ -n "pega-notes" $editor
tmux new-window -c ~/workspaces/pega -n "pega-workspace"
tmux new-window -c ~/"OneDrive - Pegasystems Inc" -n "tmp-notes" $editor -p temp.notes todo.txt
tmux select-window -t 2
tmux attach-session -d -c "~"
