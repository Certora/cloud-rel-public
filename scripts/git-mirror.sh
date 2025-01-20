#!/bin/bash

set -x

LAST_PUBLIC_HASH="$(git --git-dir="$1/.git" rev-list -1 HEAD)"
LAST_PUBLIC_MESSAGE="$(git --git-dir="$1/.git" log --format=%B -n 1 "$LAST_PUBLIC_HASH")"
PRIVATE_ORIGIN_HASH="$(echo "$LAST_PUBLIC_MESSAGE" | tail -1)"

for commit in $(git rev-list --reverse "${PRIVATE_ORIGIN_HASH}..HEAD"); do
    git format-patch -k -1 --stdout "$commit" | git --git-dir="$1/.git" am --exclude tests_delete --exclude cloud-test-private -3 -k
    OLD_MESSAGE="$(git --git-dir="$1/.git" log --format=%B -n 1 "$commit")"
    git --git-dir="$1/.git" commit --amend -m "$OLD_MESSAGE" -m "$commit"
done
