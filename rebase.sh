#!/usr/bin/env bash

set -e

git fetch upstream develop
git pull --rebase
git rebase upstream/develop

read -p "Do you want to push to origin? (y/n): " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  echo "Force updating origin."
  git push -f origin develop
else
  echo "Bye."
fi
