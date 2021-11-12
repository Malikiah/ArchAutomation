#!/bin/bash

export PATH=$PATH:~/.local/bin
cp -r $HOME/ArchAutomation/dotfiles/* $HOME/.config/
pip install konsave
konsave -i $HOME/ArchAutomation/kde.knsv
sleep 1
konsave -a kde
