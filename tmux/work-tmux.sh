#!/bin/bash

editor='nvim'

tmux new-session -d -s "dev" -n "notes" -c ~/workspaces/personal/notes $editor
tmux new-window -c ~/"OneDrive - Pegasystems Inc"/notes/ -n "pega-notes" $editor
tmux new-window -c ~/workspaces/pega/prpc/prpc-platform -n "prpc-platform"
tmux new-window -c ~/"OneDrive - Pegasystems Inc" -n "tmp-notes" $editor temp.notes
tmux attach-session -d -c "~"
