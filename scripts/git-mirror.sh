#!/bin/bash

set -xe

LAST_PUBLIC_HASH="$(git --git-dir="$1/.git" rev-list -1 HEAD)"
LAST_PUBLIC_MESSAGE="$(git --git-dir="$1/.git" log --format=%B -n 1 "$LAST_PUBLIC_HASH")"
PRIVATE_ORIGIN_HASH="$(echo "$LAST_PUBLIC_MESSAGE" | tail -1)"
REVISIONS="$(git rev-list --reverse "${PRIVATE_ORIGIN_HASH}..HEAD")"

OLD_DIR="$(pwd)"
cd "$1" || exit 1

for commit in $REVISIONS; do
    AUTHOR="$(git --git-dir="$OLD_DIR/.git" log --format='%an' -n 1 "$commit")"
    EMAIL="$(git --git-dir="$OLD_DIR/.git" log --format='%ae' -n 1 "$commit")"
    git config --global user.email "$EMAIL"
    git config --global user.name "$AUTHOR"
    git --git-dir="$OLD_DIR/.git" format-patch -k -1 --stdout "$commit" |
        git am --exclude tests_delete --exclude cloud-test-private -3 -k

    OLD_MESSAGE="$(git log --format=%B -n 1 HEAD)"
    # Add private hash to the commit message
    rm -rf tests_delete cloud-test-private
    git add -A 
    git commit --amend -m "$OLD_MESSAGE" -m "$commit"
done
