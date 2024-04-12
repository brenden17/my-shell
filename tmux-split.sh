#!/bin/bash

echo 'ssesion start...'
SESSION_NAME=${1:-tt}

if [ "$SESSION_NAME" = "tt" ]; then
        # create new session
        tmux new -s $SESSION_NAME -d
        tmux send-keys -t $SESSION_NAME 'cd ./dev && source ~/.bashrc' C-m

        # create vertical panel for next log panel
        tmux split-window -h -t $SESSION_NAME
        tmux send-keys -t $SESSION_NAME 'cd ./dev && source ~/.bashrc' C-m
        tmux split-window -v -t $SESSION_NAME
        tmux send-keys -t $SESSION_NAME 'cd ./dev && source ~/.bashrc' C-m
        tmux split-window -v -t $SESSION_NAME
        tmux send-keys -t $SESSION_NAME 'cd ./dev && source ~/.bashrc' C-m
fi
