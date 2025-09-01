# Brewfile - Complete Homebrew Setup for Mac Studio Migration
# Generated: $(date +"%Y-%m-%d")
# 
# Usage:
#   brew bundle install --file=Brewfile
#   brew bundle check --file=Brewfile
#   brew bundle cleanup --file=Brewfile --force

# Taps
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"
tap "homebrew/core"
tap "homebrew/services"

# =============================================================================
# FORMULAE - Command Line Tools
# =============================================================================

# Core Development Tools
brew "git"
brew "gh"                    # GitHub CLI
brew "git-filter-repo"
brew "git-cliff"            # Changelog generator
brew "gitleaks"             # Secrets detection

# Languages & Runtimes
brew "go"
brew "node"                 # Keep alongside nvm for system default
brew "python@3.13"
brew "python@3.12"
brew "lua"
brew "luajit"

# Build Tools
brew "cmake"
brew "make"
brew "coreutils"

# Terminal & Shell
brew "starship"             # Cross-shell prompt
brew "zsh-syntax-highlighting"
brew "zoxide"               # Smarter cd command
brew "eza"                  # Modern ls replacement
brew "bat"                  # Cat with syntax highlighting
brew "neovim"

# Cloud & Infrastructure
brew "awscli"
brew "terraform"
brew "terraform-docs"
brew "sentinel"

# Utilities
brew "the_silver_searcher"  # ag - code search
brew "ripgrep"              # rg - faster grep
brew "fd"                   # Faster find
brew "tree-sitter"
brew "diff-so-fancy"        # Better git diffs
brew "pre-commit"
brew "pipx"
brew "uv"                   # Fast Python package manager

# Networking & HTTP
brew "curl"
brew "wget"                 # NEW - Alternative to curl
brew "httpie"               # NEW - Modern HTTP client

# System Monitoring
brew "htop"                 # NEW - Process viewer
brew "procs"                # NEW - Modern ps
brew "dust"                 # NEW - Modern du

# Terminal Multiplexing
brew "tmux"                 # NEW - Terminal multiplexer

# Media Processing
brew "ffmpeg"               # NEW - Audio/video processing
brew "imagemagick"          # NEW - Image manipulation

# Developer Productivity
brew "fzf"                  # NEW - Fuzzy finder
brew "watch"                # NEW - Execute periodically
brew "ncdu"                 # NEW - Disk usage
brew "tldr"                 # NEW - Simplified man pages
brew "autojump"             # NEW - Smart navigation
brew "hyperfine"            # NEW - Benchmarking
brew "tokei"                # NEW - Code statistics
brew "jq"                   # JSON processor

# Security
brew "openssl@3"
brew "ca-certificates"

# Database
brew "redis"
brew "sqlite"

# Compression
brew "p7zip"
brew "brotli"
brew "lz4"
brew "xz"
brew "zstd"

# Other Development Tools
brew "tailscale"
brew "doormat-cli"
brew "gemini-cli"
brew "brew-file"
brew "go-task"

# =============================================================================
# CASKS - GUI Applications
# =============================================================================

# === ALREADY INSTALLED (Keep in Brewfile for reproducibility) ===

# Password Management
cask "1password"
cask "1password-cli"

# Development
cask "visual-studio-code"
cask "ghostty"              # Terminal
cask "orbstack"             # Docker/Kubernetes
cask "lm-studio"            # LLM management

# Media
cask "obs"                  # Streaming/recording

# Utilities
cask "adobe-acrobat-reader"
cask "reader"               # RSS reader
cask "shortcat"             # Keyboard navigation
cask "rar"                  # Archive utility
cask "box-drive"            # Cloud storage

# Fonts
cask "font-fira-code-nerd-font"
cask "font-fira-mono-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-noto-sans-arabic"

# Java
cask "zulu"                 # OpenJDK distribution

# Blockchain
cask "5ire"

# === TO MIGRATE (New installations) ===

# Browsers
cask "google-chrome"
cask "microsoft-edge"

# Communication & Collaboration
cask "slack"
cask "zoom"
cask "microsoft-teams"

# Productivity
cask "alfred"               # Launcher (currently Alfred 5.app)
cask "raycast"              # Command palette
cask "claude"               # AI assistant
cask "timing"               # Time tracking
cask "todoist"              # Task management

# Microsoft Office
cask "microsoft-outlook"
cask "onedrive"

# Development
cask "docker"               # Docker Desktop

# Cloud Storage
cask "google-drive"

# Media Production
cask "ecamm-live"           # Live streaming

# Hardware Support
cask "displaylink"          # Display adapters
cask "elgato-control-center"
cask "elgato-camera-hub"
cask "rode-central"         # Audio equipment

# Security & MDM
cask "okta-verify"          # 2FA
cask "nudge"                # macOS updates

# Utilities
cask "the-unarchiver"       # Archive extraction

# =============================================================================
# Mac App Store Apps (requires mas-cli)
# =============================================================================
# Uncomment if you want to manage App Store apps via Brewfile
# brew "mas"
# mas "Keynote", id: 409183694
# mas "Numbers", id: 409203825
# mas "Pages", id: 409201541

# =============================================================================
# VSCode Extensions (optional)
# =============================================================================
# vscode "ms-python.python"
# vscode "ms-vscode.cpptools"
# vscode "golang.go"
# vscode "hashicorp.terraform"

# =============================================================================
# Post-installation Notes
# =============================================================================
# 
# 1. After running `brew bundle install`:
#    - Configure Alfred preferences
#    - Sign into cloud services (Google Drive, OneDrive, etc.)
#    - Configure development environments
#
# 2. Manual installations still required:
#    - IBM enterprise apps (Mac@IBM suite)
#    - Security tools (Falcon, Code42)
#    - Google Workspace PWAs (Docs, Sheets, Slides)
#
# 3. Version managers:
#    - nvm is installed separately (not via Homebrew)
#    - Consider pyenv if Python version management needed
#
# 4. To update everything:
#    brew update && brew upgrade && brew cleanup
#
# 5. To check what's installed vs Brewfile:
#    brew bundle check --file=Brewfile
#
# 6. To remove items not in Brewfile:
#    brew bundle cleanup --file=Brewfile --force