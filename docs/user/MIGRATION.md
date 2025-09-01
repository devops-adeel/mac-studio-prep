# Annual Mac Studio Migration Guide
*Complete workflow for power users upgrading to new Mac hardware*

## Timeline Overview

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│   Day -7    │────▶│    Day 0     │────▶│   Day +1     │
│   Prepare   │     │   Migrate    │     │   Verify     │
└─────────────┘     └──────────────┘     └──────────────┘
```

---

## Phase 1: Pre-Migration (Old Mac)
*1 week before new Mac arrives*

### 1.1 Generate Current System Snapshot

```bash
cd ~/Documents/1_projects/mac-studio-prep

# Run the migration report
./HOMEBREW_MIGRATION_REPORT.md

# Backup current Homebrew state
brew bundle dump --global --force
cp ~/.Brewfile ~/dotfiles/Brewfile.$(date +%Y%m%d)
```

### 1.2 Export Critical Data

**Licenses & Credentials:**
```bash
# Export to 1Password (manual for each app)
# Common locations:
~/Library/Application Support/[AppName]/license.key
~/Library/Preferences/com.[vendor].[app].plist
```

**Development Environments:**
```bash
# Node (via nvm)
nvm list > ~/dotfiles/nvm-versions.txt

# SSH keys (if not in 1Password)
cp -R ~/.ssh ~/secure-backup/

# Git config
cp ~/.gitconfig ~/dotfiles/
```

### 1.3 Document Manual Installations

Create `manual-apps.txt`:
```
# Enterprise Apps (reinstall manually)
- Falcon (CrowdStrike)
- Mac@IBM Suite
- Code42

# App Store Apps (sign in to download)
- Keynote
- Numbers
- Pages
```

### 1.4 Clean & Commit Dotfiles

```bash
cd ~/dotfiles
git add Brewfile
git commit -m "Brewfile snapshot for Mac Studio $(date +%Y)"
git push
```

---

## Phase 2: Migration Day (New Mac)
*Fresh Mac Studio out of the box*

### 2.1 Initial macOS Setup

1. **Skip Migration Assistant** - Choose "Set Up Later"
2. **Sign into Apple ID** - For App Store access
3. **Enable Developer Mode**:
   ```bash
   # In Terminal
   xcode-select --install
   ```

### 2.2 Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH (Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 2.3 ⚡ Enable Parallel Downloads

```bash
# CRITICAL: 2-4x faster installation
echo 'export HOMEBREW_PARALLEL_DOWNLOADS=auto' >> ~/.zprofile
export HOMEBREW_PARALLEL_DOWNLOADS=auto
```

### 2.4 Clone Dotfiles & Migrate

```bash
# Clone your dotfiles
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Install everything via Brewfile
cd ~/dotfiles
brew bundle install --file=Brewfile
```

**[SCREENSHOT: Terminal showing parallel downloads progress]**

Expected output:
```
Installing alfred
Installing google-chrome
Installing slack
Installing docker
[4 downloads in parallel...]
```

### 2.5 Run Migration Script for Verification

```bash
cd ~/Documents/1_projects/mac-studio-prep
./migrate_to_homebrew.sh
```

**[SCREENSHOT: Migration script menu interface]**

Choose option `5` to generate status report.

---

## Phase 3: Post-Migration

### 3.1 Install Manual Applications

**Enterprise Tools:**
1. Download from company portal
2. Install with admin privileges
3. Authenticate with SSO

**App Store Apps:**
```bash
# If using mas (Mac App Store CLI)
mas install 409183694  # Keynote
mas install 409203825  # Numbers
mas install 409201541  # Pages
```

### 3.2 Restore Development Environment

**Node.js via nvm:**
```bash
# Install nvm (not via Homebrew)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Restore Node versions
nvm install 18
nvm install 20
nvm alias default 20
```

**SSH & Git:**
```bash
# Copy SSH keys from secure backup
cp -R ~/secure-backup/.ssh ~/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub

# Apply git config
cp ~/dotfiles/.gitconfig ~/
```

### 3.3 Application Configuration

**Sign into apps requiring authentication:**
- Browsers (Chrome, Edge)
- Communication (Slack, Teams)
- Cloud Storage (Google Drive, OneDrive)
- Development (Docker, GitHub)

**Import licenses from 1Password:**
- Alfred Powerpack
- Timing
- Other premium apps

### 3.4 System Preferences

```bash
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Dock settings
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 36

# Restart Finder/Dock
killall Finder
killall Dock
```

---

## Verification Checklist

### ✓ Core System
- [ ] Homebrew packages installed
- [ ] Dotfiles repository cloned
- [ ] Shell configured (zsh/bash)

### ✓ Development
- [ ] Git configured with credentials
- [ ] SSH keys working
- [ ] Node/nvm installed
- [ ] Docker/OrbStack running

### ✓ Applications
- [ ] All Homebrew casks installed
- [ ] Manual apps installed
- [ ] Licenses activated
- [ ] Cloud services connected

### ✓ Data
- [ ] Documents accessible
- [ ] Browser bookmarks synced
- [ ] Password manager connected

---

## Troubleshooting

### Issue: "App can't be opened" (Gatekeeper)

```bash
# Remove quarantine
xattr -dr com.apple.quarantine /Applications/AppName.app
```

### Issue: Homebrew adoption fails

```bash
# Remove existing app first
rm -rf /Applications/OldApp.app
# Then install fresh
brew install --cask app-name
```

### Issue: Slow downloads

```bash
# Verify parallel downloads enabled
echo $HOMEBREW_PARALLEL_DOWNLOADS
# Should output: auto

# Pre-fetch all packages
brew fetch $(brew bundle list --file=Brewfile)
```

### Issue: Cask not found

```bash
# Update Homebrew
brew update

# Search alternative names
brew search partial-name
```

---

## Time Estimates

| Phase | Duration |
|-------|----------|
| Pre-Migration | 30 minutes |
| Homebrew Install | 5 minutes |
| Parallel Bundle Install | 45-60 minutes |
| Manual Apps | 20 minutes |
| Configuration | 30 minutes |
| **Total** | **~2.5 hours** |

*With parallel downloads enabled, saves ~45 minutes vs sequential*

---

## Annual Maintenance

### Before Each Migration

1. **Update Brewfile** with new tools discovered during year
2. **Prune unused** applications:
   ```bash
   brew bundle cleanup --file=Brewfile
   ```
3. **Test on current machine**:
   ```bash
   brew bundle check --file=Brewfile
   ```

### After Migration

1. **Document new manual apps** discovered
2. **Update dotfiles** with configuration changes
3. **Tag version** in git:
   ```bash
   git tag mac-studio-2024
   git push --tags
   ```

---

## Quick Reference Card

```bash
# Essential Commands
brew bundle dump --global --force    # Backup current
brew bundle install --file=Brewfile  # Restore all
brew bundle check                    # Verify status
brew bundle cleanup                  # Remove unlisted

# Performance
export HOMEBREW_PARALLEL_DOWNLOADS=auto

# Migration Script
./migrate_to_homebrew.sh
  1) Backup
  2) Migrate all
  5) Report

# Reset if needed
brew uninstall --cask --zap [app]   # Complete removal
```