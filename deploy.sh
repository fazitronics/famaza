#!/bin/sh

//DIR=$(dirname "$0")

//echo "Entering directory ${DIR}"
//cd $DIR/..

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

git submodule update -f

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

# Push source and build repos.
git push origin gh-pages

# Come Back up to the Project Root
cd ..

# Commit to master
 git add .
 git commit -m "$msg"
 git push origin master
