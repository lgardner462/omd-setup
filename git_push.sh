#!/bin/bash

git-sed -f g $(whoami) tsstuff
git add . 
git commit -m -a "$@"
git push origin master
git-sed -f g tsstuff $(whoami)

