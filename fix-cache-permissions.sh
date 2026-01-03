#!/usr/bin/env bash
# Fix Nix cache permissions issue
# Run this with appropriate permissions (doas/sudo/root)

set -e

CACHE_DIR="$HOME/.cache/nix/gitv3"
PROBLEM_DIR="$CACHE_DIR/15c1px4zsspjyfk0xdfa4v479w2rf42a6cw61lnxbxw7nffyqzd1"

if [ -d "$PROBLEM_DIR" ]; then
    echo "Fixing permissions for $PROBLEM_DIR..."
    chown -R "$USER:users" "$PROBLEM_DIR"* 2>/dev/null || {
        echo "Error: Need root/doas permissions to fix this."
        echo "Run: doas chown -R $USER:users $PROBLEM_DIR*"
        exit 1
    }
    echo "Permissions fixed!"
else
    echo "Problem directory not found, may have been cleaned up."
fi

# Also fix any other directories owned by nobody
echo "Checking for other cache directories with permission issues..."
find "$CACHE_DIR" -user nobody 2>/dev/null | while read -r item; do
    echo "Fixing: $item"
    chown -R "$USER:users" "$item" 2>/dev/null || true
done

echo "Done!"


