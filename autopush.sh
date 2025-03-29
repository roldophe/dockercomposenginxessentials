#!/bin/bash


message="$1" # commit message when we want to push the code to git 

if [ -z "$message" ]; then
    # default message 
    echo "-> Usage : bash autopush.sh <commit message> 🔥"    
    exit 1
fi

git add . 
git commit -m "$message"
git push -u origin "$(git branch --show-current)"