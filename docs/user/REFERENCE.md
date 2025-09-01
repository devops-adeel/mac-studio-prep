# Command Reference
*Complete reference for all migration tools and commands*

## Core Scripts

### migrate_to_homebrew.sh

Interactive migration assistant with menu-driven interface.

```bash
./migrate_to_homebrew.sh [OPTIONS]
```

**Options:**
- `--dry-run` - Preview actions without making changes
- `--verbose` - Show detailed output
- `--force` - Skip confirmation prompts
- `--category=NAME` - Migrate specific category only

**Menu Options:**
1. Backup current Homebrew state
2. Migrate all recommended apps
3. Migrate specific category
4. Install missing CLI tools
5. Generate report only
6. Exit

**Exit Codes:**
- `0` - Success
- `1` - Homebrew not installed
- `2` - Permission denied
- `3` - User cancelled

---

### check_homebrew_availability.sh

Check which applications can be migrated to Homebrew.

```bash
./check_homebrew_availability.sh
```

**Output Format:**
```
✅ App Name -> ALREADY INSTALLED via Homebrew
🔄 App Name -> AVAILABLE as: cask-name
❌ App Name -> NOT AVAILABLE in Homebrew
```

---

## Brewfile Commands

### brew bundle

Main command for Brewfile operations.

```bash
brew bundle [SUBCOMMAND] [OPTIONS]
```

**Subcommands:**

| Command | Description | Example |
|---------|-------------|---------|
| `install` | Install all dependencies | `brew bundle install` |
| `dump` | Generate Brewfile from current | `brew bundle dump` |
| `check` | Verify all deps installed | `brew bundle check` |
| `cleanup` | Remove unlisted packages | `brew bundle cleanup --force` |
| `list` | List all dependencies | `brew bundle list` |
| `exec` | Run command with deps | `brew bundle exec -- CMD` |

**Options:**

| Flag | Description | Default |
|------|-------------|---------|
| `--file=PATH` | Brewfile location | `./Brewfile` |
| `--global` | Use ~/.Brewfile | false |
| `--no-upgrade` | Skip upgrading outdated | false |
| `--force` | Force cleanup removal | false |
| `--all` | Include all in list | false |
| `--cask` | Casks only | false |
| `--formula` | Formulae only | false |

---

## Cask Management

### Installing Casks

```bash
# Standard installation
brew install --cask APPLICATION

# Adopt existing installation
brew install --cask --adopt APPLICATION

# Skip quarantine (trusted apps only)
brew install --cask --no-quarantine APPLICATION

# Custom location
brew install --cask --appdir=~/Applications APPLICATION
```

### Uninstalling Casks

```bash
# Standard removal
brew uninstall --cask APPLICATION

# Complete removal (including preferences)
brew uninstall --cask --zap APPLICATION

# Force removal
brew uninstall --cask --force APPLICATION
```

### Searching Casks

```bash
# Search by name
brew search --cask KEYWORD

# Search with descriptions
brew search --cask --desc KEYWORD

# List all available casks
brew search --cask ""
```

### Cask Information

```bash
# Show cask details
brew info --cask APPLICATION

# List installed casks
brew list --cask

# Show outdated casks
brew outdated --cask

# Include auto-updating apps
brew outdated --cask --greedy
```

---

## Environment Variables

### Performance

```bash
# Enable parallel downloads (2-4x faster)
export HOMEBREW_PARALLEL_DOWNLOADS=auto

# Skip auto-update during install
export HOMEBREW_NO_AUTO_UPDATE=1

# Skip install cleanup
export HOMEBREW_NO_INSTALL_CLEANUP=1
```

### Configuration

```bash
# Default Brewfile location
export HOMEBREW_BUNDLE_FILE=~/dotfiles/Brewfile

# Skip upgrading during bundle
export HOMEBREW_BUNDLE_NO_UPGRADE=1

# Default cask options
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
```

### Debugging

```bash
# Verbose output
export HOMEBREW_VERBOSE=1

# Debug mode
export HOMEBREW_DEBUG=1

# Show build output
export HOMEBREW_VERBOSE_USING_DOTS=1
```

---

## Brewfile Syntax

### Basic Structure

```ruby
# Taps (repositories)
tap "homebrew/cask"
tap "homebrew/cask-fonts"

# Formulae (CLI tools)
brew "git"
brew "node"

# Casks (GUI applications)
cask "google-chrome"
cask "slack"

# Mac App Store
mas "Keynote", id: 409183694

# VSCode extensions
vscode "ms-python.python"
```

### Advanced Options

```ruby
# Specific version
brew "postgresql@14"

# With options
brew "nginx", restart_service: true

# With arguments
cask "firefox", args: { language: "en-US" }

# Conditional installation
cask "docker" unless File.exist?("/Applications/Docker.app")

# Environment-based
if ENV['WORK_MACHINE']
  cask "microsoft-teams"
end
```

---

## Migration Workflow Commands

### Complete Migration Sequence

```bash
# 1. On old Mac - Create backup
cd ~/dotfiles
brew bundle dump --global --force
git add Brewfile
git commit -m "Pre-migration backup"
git push

# 2. On new Mac - Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Enable optimizations
export HOMEBREW_PARALLEL_DOWNLOADS=auto

# 4. Clone and install
git clone https://github.com/USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew bundle install --file=Brewfile

# 5. Verify
brew bundle check
```

---

## Troubleshooting Commands

### Diagnosis

```bash
# Check Homebrew health
brew doctor

# Verify installation
brew config

# Check for issues
brew missing
brew broken
```

### Cleanup

```bash
# Remove old versions
brew cleanup

# Remove cache
brew cleanup --prune=all

# Fix permissions
sudo chown -R $(whoami) $(brew --prefix)/*
```

### Reset

```bash
# Reinstall cask
brew reinstall --cask APPLICATION

# Reset Homebrew
brew update-reset

# Untap repository
brew untap USER/REPO
```

---

## Common Patterns

### Bulk Operations

```bash
# Install multiple casks
apps=(chrome slack docker zoom)
for app in "${apps[@]}"; do
    brew install --cask "$app"
done

# Adopt all existing
for app in /Applications/*.app; do
    name=$(basename "$app" .app | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
    brew install --cask --adopt "$name" 2>/dev/null
done
```

### Parallel Fetch

```bash
# Pre-download all packages (faster)
brew fetch $(brew bundle list --file=Brewfile)

# Then install from cache
brew bundle install --file=Brewfile
```

### Selective Installation

```bash
# Only casks
brew bundle install --file=Brewfile --cask

# Only formulae  
brew bundle install --file=Brewfile --formula

# Skip specific
grep -v "docker" Brewfile | brew bundle --file=-
```

---

## Quick Decision Tree

```
Need to install app?
├─ Is it in Homebrew?
│  ├─ Yes: brew install --cask APP
│  └─ No: Download manually
│
├─ Already installed manually?
│  ├─ Yes: brew install --cask --adopt APP
│  └─ No: Fresh install
│
└─ Having issues?
   ├─ App running: Kill process first
   ├─ Checksum fail: brew reinstall
   └─ Not found: brew update && search
```

---

## Performance Benchmarks

| Operation | Sequential | Parallel | Speedup |
|-----------|------------|----------|---------|
| 10 casks | 5 min | 2 min | 2.5x |
| 25 casks | 12 min | 4 min | 3x |
| 50 casks | 25 min | 7 min | 3.5x |
| Bundle install | 45 min | 15 min | 3x |

*With `HOMEBREW_PARALLEL_DOWNLOADS=auto`*

---

## Security Considerations

### Verification

```bash
# Check SHA256
brew fetch --cask APP
shasum -a 256 ~/Library/Caches/Homebrew/downloads/[FILE]

# Verify signature
codesign -dv --verbose=4 /Applications/App.app
```

### Quarantine

```bash
# Check quarantine status
xattr -l /Applications/App.app | grep quarantine

# Remove quarantine (trusted only)
xattr -dr com.apple.quarantine /Applications/App.app
```

---

## Useful Aliases

Add to `~/.zshrc` or `~/.bashrc`:

```bash
# Brewfile management
alias brewdump='brew bundle dump --global --force'
alias brewinstall='brew bundle install --global'
alias brewcheck='brew bundle check --global'
alias brewclean='brew bundle cleanup --global --force'

# Quick operations
alias cask='brew install --cask'
alias uncask='brew uninstall --cask'
alias recask='brew reinstall --cask'

# Maintenance
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewfix='brew doctor && brew missing'

# Performance
alias brewfast='export HOMEBREW_PARALLEL_DOWNLOADS=auto'
```