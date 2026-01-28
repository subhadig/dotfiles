#!/usr/bin/env bash

editor='nvim'
session_name="dev"

tmux has-session -t "$session_name" 2>/dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s "$session_name" -n "notes" -c ~/workspaces/personal/notes $editor
    tmux new-window -c ~/"OneDrive - Pegasystems Inc"/notes/ -n "pega-notes" $editor
    tmux new-window -c ~/workspaces/pega/infinity -n "pega-workspace"
    tmux new-window -c ~/"OneDrive - Pegasystems Inc" -n "tmp-notes" $editor -p temp.notes todo.md
    tmux select-window -t 2
fi

tmux attach-session -d -c "~" -t "$session_name"
