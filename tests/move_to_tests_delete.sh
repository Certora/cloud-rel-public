#!/bin/bash

REPO_PATH="/Users/nivvaknin/CERTORA/cloud-rel-private"
BRANCH_PREFIX="move-to-tests-delete"
MAIN_BRANCH="main"
DATE=$(date +%Y%m%d%H%M%S)

# Navigate to the repository
cd $REPO_PATH || { echo "Repository not found at $REPO_PATH"; exit 1; }

# Ensure the repo is clean
git reset --hard
git clean -fd

# Create branch, move file, and push
branch_name="${BRANCH_PREFIX}-${DATE}"
file_outside="file_outside_${DATE}.txt"
file_inside="tests_delete/file_inside_${DATE}.txt"

echo "Creating branch: $branch_name"
git checkout -b $branch_name

echo "Adding file outside tests_delete: $file_outside"
echo "This file will be moved into tests_delete." > $file_outside
git add $file_outside
git commit -m "Add file outside tests_delete"

echo "Moving file into tests_delete"
mkdir -p $(dirname $file_inside)
git mv $file_outside $file_inside
git commit -m "Move file into tests_delete"

echo "Pushing branch: $branch_name"
git push origin $branch_name

# Open a PR and merge it
echo "Opening a PR for branch: $branch_name"
gh pr create --base $MAIN_BRANCH --head $branch_name --title "Move file into tests_delete" --body "This PR tests moving a file into tests_delete."

echo "Merging the PR..."
gh pr merge --squash --delete-branch 
