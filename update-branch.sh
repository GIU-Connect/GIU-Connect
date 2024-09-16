#!/bin/bash

# Get a list of all local branches
branches=$(git branch | sed 's/^[ *]*//')

# Loop through each branch
for branch in $branches; do
    # Skip the branch we are currently on
    if [ "$branch" != "$(git symbolic-ref --short HEAD)" ]; then
        # Checkout the branch
        git checkout $branch
        # Reset the branch to match the remote
        git reset --hard origin/$branch
    fi
done

# Checkout the original branch
git checkout master  # or whatever branch you prefer to return to

