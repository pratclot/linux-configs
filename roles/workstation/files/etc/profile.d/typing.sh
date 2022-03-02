#!/bin/bash

2>/dev/null bind '"\e[A": history-search-backward'
2>/dev/null bind '"\e[B": history-search-forward'
2>/dev/null bind '"\e\e[D": backward-word'
2>/dev/null bind '"\e\e[C": forward-word'
