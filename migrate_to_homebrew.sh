#!/bin/bash

# Homebrew Migration Script
# This script helps migrate existing applications to Homebrew management
# Generated: $(date +"%Y-%m-%d")

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Header
echo "========================================="
echo "   Homebrew Migration Assistant"
echo "========================================="
echo

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_error "Homebrew is not installed!"
    echo "Install it first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Backup current Homebrew state
backup_brewfile() {
    local backup_file="$HOME/Brewfile.backup.$(date +%Y%m%d_%H%M%S)"
    print_info "Backing up current Homebrew state to $backup_file"
    brew bundle dump --force --file="$backup_file"
    print_status "Backup created: $backup_file"
}

# Function to check if app is installed
is_app_installed() {
    local app_name="$1"
    if [ -d "/Applications/$app_name.app" ] || [ -d "/Applications/$app_name" ]; then
        return 0
    fi
    return 1
}

# Function to check if cask is already installed
is_cask_installed() {
    local cask_name="$1"
    if brew list --cask | grep -q "^$cask_name\$"; then
        return 0
    fi
    return 1
}

# Function to migrate an app
migrate_app() {
    local app_display_name="$1"
    local cask_name="$2"
    
    echo
    print_info "Processing: $app_display_name"
    
    # Check if already managed by Homebrew
    if is_cask_installed "$cask_name"; then
        print_status "$app_display_name is already managed by Homebrew"
        return 0
    fi
    
    # Check if app exists on system
    if is_app_installed "$app_display_name"; then
        print_warning "$app_display_name found on system but not managed by Homebrew"
        echo -n "  Would you like to adopt it with Homebrew? (y/n): "
        read -r response
        if [[ "$response" == "y" ]]; then
            if brew install --cask --adopt "$cask_name" 2>/dev/null; then
                print_status "Successfully adopted $app_display_name"
            else
                # If adopt fails, try regular install
                print_warning "Adopt failed, trying regular install..."
                if brew install --cask "$cask_name"; then
                    print_status "Successfully installed $app_display_name"
                else
                    print_error "Failed to install $app_display_name"
                fi
            fi
        fi
    else
        echo -n "  $app_display_name not found. Install via Homebrew? (y/n): "
        read -r response
        if [[ "$response" == "y" ]]; then
            if brew install --cask "$cask_name"; then
                print_status "Successfully installed $app_display_name"
            else
                print_error "Failed to install $app_display_name"
            fi
        fi
    fi
}

# Main menu
show_menu() {
    echo
    echo "What would you like to do?"
    echo "1) Backup current Homebrew state"
    echo "2) Migrate all recommended apps"
    echo "3) Migrate specific category"
    echo "4) Install missing CLI tools"
    echo "5) Generate report only"
    echo "6) Exit"
    echo
    echo -n "Enter choice [1-6]: "
}

# Migrate all apps
migrate_all_apps() {
    print_info "Starting migration of all recommended applications..."
    
    # Define apps to migrate
    declare -a apps=(
        "Alfred 5:alfred"
        "Claude:claude"
        "Docker:docker"
        "Google Chrome:google-chrome"
        "Microsoft Edge:microsoft-edge"
        "Microsoft Outlook:microsoft-outlook"
        "Microsoft Teams:microsoft-teams"
        "OneDrive:onedrive"
        "Raycast:raycast"
        "Slack:slack"
        "zoom.us:zoom"
        "The Unarchiver:the-unarchiver"
        "Timing:timing"
        "Todoist:todoist"
        "DisplayLink Manager:displaylink"
        "Elgato Control Center:elgato-control-center"
        "Elgato Camera Hub:elgato-camera-hub"
        "Ecamm Live:ecamm-live"
        "RODE Central:rode-central"
        "Okta Verify:okta-verify"
        "Google Drive:google-drive"
        "Nudge:nudge"
    )
    
    for app_pair in "${apps[@]}"; do
        IFS=':' read -r display_name cask_name <<< "$app_pair"
        migrate_app "$display_name" "$cask_name"
    done
}

# Install CLI tools
install_cli_tools() {
    print_info "Installing recommended CLI tools..."
    
    local tools=(
        "wget"
        "htop"
        "tmux"
        "ffmpeg"
        "imagemagick"
        "watch"
        "fzf"
        "ncdu"
        "tldr"
        "autojump"
        "dust"
        "procs"
        "hyperfine"
        "tokei"
        "httpie"
        "ripgrep"
        "fd"
    )
    
    for tool in "${tools[@]}"; do
        if brew list --formula | grep -q "^$tool\$"; then
            print_status "$tool is already installed"
        else
            print_info "Installing $tool..."
            if brew install "$tool"; then
                print_status "$tool installed successfully"
            else
                print_error "Failed to install $tool"
            fi
        fi
    done
}

# Generate report
generate_report() {
    print_info "Generating migration report..."
    
    local report_file="./homebrew_migration_status_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "Homebrew Migration Status Report"
        echo "Generated: $(date)"
        echo "================================="
        echo
        echo "Installed Casks:"
        brew list --cask
        echo
        echo "Installed Formulae:"
        brew list --formula
        echo
        echo "Applications in /Applications not managed by Homebrew:"
        for app in /Applications/*.app; do
            app_name=$(basename "$app" .app)
            if ! brew list --cask 2>/dev/null | grep -qi "$(echo "$app_name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"; then
                echo "  - $app_name"
            fi
        done
    } > "$report_file"
    
    print_status "Report saved to: $report_file"
}

# Main loop
while true; do
    show_menu
    read -r choice
    
    case $choice in
        1)
            backup_brewfile
            ;;
        2)
            migrate_all_apps
            ;;
        3)
            echo "Categories:"
            echo "1) Browsers"
            echo "2) Communication"
            echo "3) Productivity"
            echo "4) Development"
            echo "5) Media"
            echo -n "Select category [1-5]: "
            read -r cat_choice
            case $cat_choice in
                1)
                    migrate_app "Google Chrome" "google-chrome"
                    migrate_app "Microsoft Edge" "microsoft-edge"
                    ;;
                2)
                    migrate_app "Slack" "slack"
                    migrate_app "zoom.us" "zoom"
                    migrate_app "Microsoft Teams" "microsoft-teams"
                    ;;
                3)
                    migrate_app "Alfred 5" "alfred"
                    migrate_app "Raycast" "raycast"
                    migrate_app "Claude" "claude"
                    migrate_app "Timing" "timing"
                    migrate_app "Todoist" "todoist"
                    ;;
                4)
                    migrate_app "Docker" "docker"
                    ;;
                5)
                    migrate_app "Ecamm Live" "ecamm-live"
                    migrate_app "Elgato Control Center" "elgato-control-center"
                    ;;
                *)
                    print_error "Invalid category"
                    ;;
            esac
            ;;
        4)
            install_cli_tools
            ;;
        5)
            generate_report
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            ;;
    esac
done