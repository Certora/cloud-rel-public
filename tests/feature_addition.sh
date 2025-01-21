#!/bin/bash

REPO_PATH="/Users/nivvaknin/CERTORA/cloud-rel-private"
BRANCH_PREFIX="feature-branch"
MAIN_BRANCH="main"
DATE=$(date +%Y%m%d%H%M%S)

# Navigate to the repository
cd $REPO_PATH || { echo "Repository not found at $REPO_PATH"; exit 1; }

# Ensure the repo is clean
git reset --hard
git clean -fd

# Create feature branch, add file, and push
feature_branch="${BRANCH_PREFIX}-${DATE}"
feature_file="feature_file_${DATE}.txt"

echo "Creating branch: $feature_branch"
git checkout -b $feature_branch

echo "Adding new feature file: $feature_file"
echo "This is a feature file." > $feature_file
git add $feature_file
git commit -m "Add feature file"

echo "Pushing branch: $feature_branch"
git push origin $feature_branch

# Open a PR and merge it
echo "Opening a PR for branch: $feature_branch"
gh pr create --base $MAIN_BRANCH --head $feature_branch --title "Add feature file" --body "This PR adds a feature file for testing purposes."

echo "Merging the PR..."
gh pr merge --squash --delete-branch --auto
