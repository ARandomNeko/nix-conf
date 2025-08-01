#!/bin/bash
echo "=== Portal Debug Script ==="
echo

echo "1. Checking portal services:"
systemctl --user is-active xdg-desktop-portal.service
systemctl --user is-active xdg-desktop-portal-gtk.service
echo

echo "2. Checking portal config:"
cat ~/.config/xdg-desktop-portal/portals.conf
echo

echo "3. Checking environment variables:"
env | grep -E "(GTK_USE_PORTAL|NIXOS_XDG_OPEN_USE_PORTAL|XDG_CURRENT_DESKTOP)"
echo

echo "4. Testing file chooser portal:"
gdbus call --session --dest org.freedesktop.portal.Desktop --object-path /org/freedesktop/portal/desktop --method org.freedesktop.portal.FileChooser.OpenFile "" "Test" {} || echo "Portal call failed"
echo

echo "5. Running Zen browser with debug output:"
echo "Run this command to see portal debug info:"
echo "G_MESSAGES_DEBUG=all flatpak run --log-session-bus com.zen_browser.zen 2>&1 | grep -i portal"