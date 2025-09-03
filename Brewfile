# Brewfile - Complete Homebrew Setup for Mac Studio Migration
# Generated: $(date +"%Y-%m-%d")
# 
# Usage:
#   brew bundle install --file=Brewfile
#   brew bundle check --file=Brewfile
#   brew bundle cleanup --file=Brewfile --force

# Taps

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
brew "bat"                  # Cat with syntax highlighting (kept for showing syntax-highlighted snippets)
brew "neovim"


# # Cloud & Infrastructure
# brew "awscli"
# brew "terraform"
# brew "terraform-docs"
# brew "sentinel"


# Search & Code Utilities
brew "the_silver_searcher"  # ag - keeping during ripgrep transition (remove in 6 months)
brew "ripgrep"              # rg - primary code search tool
brew "fd"                   # Faster find
brew "pre-commit"

# Python Package Management
brew "pipx"                 # Install Python CLI tools in isolated environments
brew "uv"                   # Fast Python package manager (10-100x faster than pip)

# Networking & HTTP
brew "curl"                 # Universal HTTP client
brew "httpie"               # Better for API testing with authentication

# System Monitoring
# Note: Visual monitoring tools removed - using Grafana/observability instead


# Media Processing
# brew "ffmpeg"               # NEW - Audio/video processing
# brew "imagemagick"          # NEW - Image manipulation

# Data Processing & Productivity
brew "fzf"                  # Fuzzy finder for interactive selection
brew "watch"                # Execute periodically (kept for simple monitoring)
brew "tldr"                 # Simplified man pages
brew "jq"                   # JSON processor
brew "yq"                   # YAML processor (essential for Docker configs)

# Security
brew "openssl@3"
brew "ca-certificates"

# Compression
brew "p7zip"
brew "brotli"
brew "lz4"
brew "xz"
brew "zstd"

# Other Development Tools
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
cask "ghostty"              # Terminal
cask "orbstack"             # Docker/Kubernetes
cask "lm-studio"            # LLM management

# Media
cask "obs"                  # Streaming/recording

# Utilities
cask "adobe-acrobat-reader"
cask "reader"               # RSS reader
# cask "shortcat"           # Keyboard navigation
cask "rar"                  # Archive utility
cask "mouseless"	    # Keyboard navigation
cask "keymapp"		    # ZSA voyager keyboard configurator.

# Fonts
cask "font-fira-code-nerd-font"
cask "font-fira-mono-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-noto-sans-arabic"

# Java
cask "zulu"                 # OpenJDK distribution

# === TO MIGRATE (New installations) ===

# Browsers
# cask "google-chrome"
cask "microsoft-edge"

# Communication & Collaboration
cask "slack"
cask "zoom"
cask "microsoft-teams"

# Productivity
cask "alfred"               # Launcher (currently Alfred 5.app)
cask "claude"               # AI assistant
cask "claude-code"
cask "timing"               # Time tracking
cask "todoist"              # Task management

# Media Production
# cask "ecamm-live"           # Live streaming

# Hardware Support
cask "displaylink"          # Display adapters
cask "elgato-control-center"
cask "elgato-camera-hub"
cask "rode-central"         # Audio equipment

# Security & MDM
# cask "okta-verify"          # 2FA
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
# 3. Python Development:
#    - Use 'uv' for virtual environments and package management
#    - uv venv .venv && source .venv/bin/activate
#    - uv pip install -r requirements.txt (10-100x faster than pip)
#    - No pyenv needed since standardized on Python 3.13
#
# 4. To update everything:
#    brew update && brew upgrade && brew cleanup
#
# 5. To check what's installed vs Brewfile:
#    brew bundle check --file=Brewfile
#
# 6. To remove items not in Brewfile:
#    brew bundle cleanup --file=Brewfile --force
#
# 7. Tool Migration Timeline:
#    - Keep the_silver_searcher for 6 months during ripgrep transition
#    - Observability tools (Grafana/Langfuse) will gradually replace CLI monitoring
#    - Final target: ~25 essential tools after full observability integration
