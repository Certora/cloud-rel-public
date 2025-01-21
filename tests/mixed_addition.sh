#!/bin/bash

REPO_PATH="/Users/nivvaknin/CERTORA/cloud-rel-private"
BRANCH_PREFIX="mixed-branch"
MAIN_BRANCH="main"
DATE=$(date +%Y%m%d%H%M%S)

# Navigate to the repository
cd $REPO_PATH || { echo "Repository not found at $REPO_PATH"; exit 1; }

# Ensure the repo is clean
git reset --hard
git clean -fd

# Create mixed branch, add files, and push
mixed_branch="${BRANCH_PREFIX}-${DATE}"
feature_file="feature_file_${DATE}_mix.txt"
test_file="tests_delete/test_file_${DATE}_mix.txt"

echo "Creating branch: $mixed_branch"
git checkout -b $mixed_branch

echo "Adding new feature file: $feature_file"
echo "This is a feature file in mixed branch." > $feature_file
git add $feature_file
git commit -m "Add feature file in mixed branch."

echo "Adding new test file: $test_file"
mkdir -p $(dirname $test_file)
echo "This is a test file in mixed branch." > $test_file
git add $test_file
git commit -m "Add test file in mixed branch."

echo "Pushing branch: $mixed_branch"
git push origin $mixed_branch

# Open a PR and merge it
echo "Opening a PR for branch: $mixed_branch"
gh pr create --base $MAIN_BRANCH --head $mixed_branch --title "Add feature and test files" --body "This PR adds both feature and test files for testing purposes."

echo "Merging the PR..."
gh pr merge --squash --delete-branch
