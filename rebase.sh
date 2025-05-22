#!/usr/bin/env bash

set -e

git fetch upstream
git pull --rebase
git rebase upstream/v2-develop

read -p "Do you want to push to origin? (y/n): " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  echo "Force updating origin."
  git push -f origin v2-develop
else
  echo "Bye."
fi
