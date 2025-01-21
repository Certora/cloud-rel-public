#!/bin/bash

REPO_PATH="/Users/nivvaknin/CERTORA/cloud-rel-private"
BRANCH_PREFIX="test-branch"
MAIN_BRANCH="main"
DATE=$(date +%Y%m%d%H%M%S)

# Navigate to the repository
cd $REPO_PATH || { echo "Repository not found at $REPO_PATH"; exit 1; }

# Ensure the repo is clean
git reset --hard
git clean -fd

# Create test branch, add test file, and push
test_branch="${BRANCH_PREFIX}-${DATE}"
test_file="test_delete/test_file_${DATE}.txt"

echo "Creating branch: $test_branch"
git checkout -b $test_branch

echo "Adding new test file: $test_file"
mkdir -p $(dirname $test_file)
echo "This is a test file." > $test_file
git add $test_file
git commit -m "Add test file"

echo "Pushing branch: $test_branch"
git push origin $test_branch

# Open a PR and merge it
echo "Opening a PR for branch: $test_branch"
gh pr create --base $MAIN_BRANCH --head $test_branch --title "Add test file" --body "This PR adds a test file under test_delete."

echo "Merging the PR..."
gh pr merge --squash --delete-branch --auto
