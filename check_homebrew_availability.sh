#!/bin/bash

# Script to check Homebrew cask availability for all installed applications
# Generated on $(date)

echo "=== Checking Homebrew Cask Availability for Non-Homebrew Apps ==="
echo

# Get list of currently installed casks
brew list --cask 2>/dev/null > /tmp/installed_casks.txt

# Apps to check (from /Applications scan)
apps=(
"1Password for Safari"
"Alfred 5"
"Claude"
"Code42-AAT"
"Code42"
"DisplayLink Manager"
"DisplayLink Software Uninstaller"
"Docker"
"Ecamm Live Virtual Camera"
"Ecamm Live"
"Elgato Camera Hub"
"Elgato Capture Device Utility"
"Elgato Control Center"
"Elgato Thunderbolt Dock Utility"
"Falcon"
"Google Chrome"
"Google Docs"
"Google Drive"
"Google Sheets"
"Google Slides"
"Keynote"
"Mac@IBM App Store"
"Mac@IBM Data Shift"
"Mac@IBM Notifications"
"Microsoft Edge"
"Microsoft Outlook"
"Microsoft Teams"
"Numbers"
"Okta Verify"
"OneDrive"
"Pages"
"Raycast"
"RODE Central"
"Slack"
"The Unarchiver"
"Timing"
"Todoist"
"zoom.us"
"DEPNotify"
"Nudge"
)

echo "Checking availability for each app..."
echo "Format: [App Name] -> [Cask Status]"
echo "-----------------------------------"

for app in "${apps[@]}"; do
    # Normalize app name for search
    search_name=$(echo "$app" | tr '[:upper:]' '[:lower:]' | sed 's/\.app$//' | tr ' ' '-' | sed 's/-5$//' | sed 's/@/-at-/g')
    
    # Check if already installed via Homebrew
    if grep -qi "${search_name}" /tmp/installed_casks.txt; then
        echo "✅ $app -> ALREADY INSTALLED via Homebrew"
        continue
    fi
    
    # Search for exact match first
    result=$(brew search --cask "^${search_name}$" 2>/dev/null | head -1)
    
    # If no exact match, try partial search
    if [ -z "$result" ]; then
        result=$(brew search --cask "${search_name}" 2>/dev/null | grep -i "${search_name}" | head -1)
    fi
    
    # Special cases and known mappings
    case "$app" in
        "zoom.us") result="zoom" ;;
        "Todoist") result="todoist" ;;
        "Alfred 5") result="alfred" ;;
        "Google Drive") result="google-drive" ;;
        "RODE Central") result="rode-central" ;;
        "Ecamm Live") result="ecamm-live" ;;
        *) ;;
    esac
    
    if [ -n "$result" ]; then
        echo "🔄 $app -> AVAILABLE as: $result"
    else
        echo "❌ $app -> NOT AVAILABLE in Homebrew"
    fi
done

rm -f /tmp/installed_casks.txt