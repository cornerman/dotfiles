#!/bin/bash

rm -rf ~/.local/share/qutebrowser/{cmd-history,history,local-storage}
echo "restart" >> "$QUTE_FIFO"
