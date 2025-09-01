# Extending the Migration Tools
*How-to Guide for Developers*

## Adding New Application Detection

### Step 1: Update Detection Patterns

Edit `check_homebrew_availability.sh`:

```bash
# Add to apps array
apps+=(
    "Your New App"
    "Another App Suite"
)

# Add special case mapping
case "$app" in
    "Your New App") result="your-new-app-cask" ;;
    # Existing mappings...
esac
```

### Step 2: Handle Edge Cases

For apps with version numbers or special characters:

```bash
normalize_app_name() {
    local app="$1"
    
    # Remove version numbers
    app=$(echo "$app" | sed 's/ [0-9]*$//')
    
    # Handle special characters
    app=$(echo "$app" | tr '@' '-at-')
    app=$(echo "$app" | tr '+' '-plus-')
    
    # Standard normalization
    echo "$app" | tr '[:upper:]' '[:lower:]' | tr ' ' '-'
}
```

### Step 3: Test Detection

```bash
# Test your pattern
./check_homebrew_availability.sh | grep "Your New App"

# Verify cask name
brew info --cask your-new-app-cask
```

## Custom Brewfile Sections

### Machine-Specific Configuration

Create `Brewfile.local` for machine-specific packages:

```ruby
# Brewfile.local - Work machine only
cask "vmware-fusion"     # Work virtualization
cask "microsoft-office"   # Full office suite
brew "postgresql@14"      # Specific version for project
```

Modify main script to source local config:

```bash
generate_brewfile() {
    cat > Brewfile <<EOF
# Main Brewfile
$(brew bundle dump --file=-)

# Machine-specific additions
if [ -f "Brewfile.local" ]; then
    cat Brewfile.local >> Brewfile
fi
EOF
}
```

### Conditional Installation

Add environment detection:

```ruby
# In Brewfile
if ENV['MACHINE_TYPE'] == 'work'
  cask "slack"
  cask "zoom"
elsif ENV['MACHINE_TYPE'] == 'personal'
  cask "discord"
  cask "steam"
end
```

Set environment before running:

```bash
export MACHINE_TYPE=work
brew bundle install
```

## Adding Package Managers

### npm Global Packages

Create `migrate_npm_packages.sh`:

```bash
#!/bin/bash

# Export current npm globals
export_npm_packages() {
    npm list -g --depth=0 --json > npm-globals.json
}

# Import npm globals
import_npm_packages() {
    cat npm-globals.json | \
    jq -r '.dependencies | keys[]' | \
    grep -v "^npm$" | \
    xargs -I {} npm install -g {}
}

# Integration point
if command -v npm >/dev/null; then
    echo "Migrating npm packages..."
    import_npm_packages
fi
```

### Python pip Packages

```bash
# Export pip packages
pip freeze > requirements.txt

# Import on new machine
pip install -r requirements.txt
```

## Custom Migration Categories

Extend the menu system in `migrate_to_homebrew.sh`:

```bash
show_category_menu() {
    echo "Categories:"
    echo "1) Browsers"
    echo "2) Communication"
    echo "3) Development"
    echo "4) Creative Tools"    # New category
    echo "5) Security Tools"    # New category
}

migrate_creative_tools() {
    migrate_app "Pixelmator Pro" "pixelmator-pro"
    migrate_app "Final Cut Pro" "final-cut-pro"
    migrate_app "Logic Pro" "logic-pro"
}

migrate_security_tools() {
    migrate_app "1Password" "1password"
    migrate_app "Little Snitch" "little-snitch"
    migrate_app "Micro Snitch" "micro-snitch"
}
```

## Pre/Post Migration Hooks

### Backup Preferences Before Migration

```bash
pre_migration() {
    local app_name="$1"
    local bundle_id="$2"
    
    # Backup preferences
    if [ -n "$bundle_id" ]; then
        defaults export "$bundle_id" \
            ~/Library/Preferences/backup/"$bundle_id".plist
    fi
    
    # Backup application support
    if [ -d ~/Library/Application\ Support/"$app_name" ]; then
        cp -R ~/Library/Application\ Support/"$app_name" \
            ~/Library/Application\ Support/backup/
    fi
}

# Usage in migration
pre_migration "Slack" "com.tinyspeck.slackmacgap"
migrate_app "Slack" "slack"
```

### Restore After Migration

```bash
post_migration() {
    local app_name="$1"
    local bundle_id="$2"
    
    # Restore preferences
    if [ -f ~/Library/Preferences/backup/"$bundle_id".plist ]; then
        defaults import "$bundle_id" \
            ~/Library/Preferences/backup/"$bundle_id".plist
    fi
    
    # Restart app to apply
    killall "$app_name" 2>/dev/null || true
    open -a "$app_name"
}
```

## Advanced Cask Detection

### Using brew search API

```bash
check_cask_availability_advanced() {
    local app_name="$1"
    local search_terms=("$app_name")
    
    # Generate search variations
    search_terms+=("${app_name// /-}")
    search_terms+=("${app_name// /}")
    search_terms+=("${app_name,,}")  # lowercase
    
    for term in "${search_terms[@]}"; do
        result=$(brew search --cask "$term" 2>/dev/null | head -1)
        if [ -n "$result" ]; then
            echo "$result"
            return 0
        fi
    done
    
    return 1
}
```

### Fuzzy Matching

```bash
# Install fuzzy finder
brew install fzf

find_cask_fuzzy() {
    local app_name="$1"
    
    # Get all available casks
    brew search --cask "" | \
    fzf --filter="$app_name" | \
    head -1
}
```

## Performance Profiling

### Add Timing to Functions

```bash
time_function() {
    local func_name="$1"
    shift
    
    local start=$(date +%s%N)
    "$func_name" "$@"
    local end=$(date +%s%N)
    
    local duration=$((($end - $start) / 1000000))
    echo "[$func_name took ${duration}ms]" >&2
}

# Usage
time_function migrate_app "Docker" "docker"
```

### Parallel Processing

```bash
migrate_apps_parallel() {
    local -a apps=("$@")
    
    # Export function for parallel execution
    export -f migrate_app
    export -f is_cask_installed
    
    # Run migrations in parallel
    printf '%s\n' "${apps[@]}" | \
    xargs -P 4 -I {} bash -c 'migrate_app "$@"' _ {}
}
```

## Testing Extensions

### Unit Test Framework

```bash
# test_extensions.sh
source ./migrate_to_homebrew.sh

test_normalize_special_chars() {
    local result=$(normalize_app_name "Mac@IBM")
    assert_equals "mac-at-ibm" "$result"
}

test_fuzzy_match() {
    local result=$(find_cask_fuzzy "Chrome")
    assert_equals "google-chrome" "$result"
}

run_tests() {
    test_normalize_special_chars
    test_fuzzy_match
    echo "All tests passed!"
}
```

### Integration Testing

```bash
# Test with dry run
DRY_RUN=1 ./migrate_to_homebrew.sh

# Test specific category
./migrate_to_homebrew.sh --category=browsers --dry-run
```

## Contributing Guidelines

1. **Test locally first** - Use `--dry-run` flag
2. **Follow naming conventions** - Lowercase, hyphenated
3. **Document special cases** - Add comments for edge cases
4. **Update tests** - Add test cases for new features
5. **Performance impact** - Profile if adding loops/network calls

## Common Extension Patterns

### Pattern 1: New Data Source

```bash
# Import from third-party tool
import_from_setapp() {
    # List Setapp applications
    ls /Applications/Setapp/*.app | while read app; do
        app_name=$(basename "$app" .app)
        # Check if available in Homebrew
        if check_cask_availability "$app_name"; then
            migrate_app "$app_name" "$(get_cask_name "$app_name")"
        fi
    done
}
```

### Pattern 2: Export Formats

```bash
# Export as JSON
export_as_json() {
    brew bundle dump --file=- | \
    ruby -rjson -e 'puts JSON.pretty_generate(
        STDIN.readlines.map { |l| 
            l.strip.split(" ", 2) 
        }.to_h
    )'
}

# Export as YAML
export_as_yaml() {
    brew bundle dump --file=- | \
    ruby -ryaml -e 'puts YAML.dump(
        STDIN.readlines.map { |l| 
            l.strip.split(" ", 2) 
        }.to_h
    )'
}
```

### Pattern 3: Validation

```bash
validate_brewfile() {
    local brewfile="${1:-Brewfile}"
    
    # Check syntax
    ruby -c "$brewfile" 2>/dev/null || {
        echo "Syntax error in Brewfile"
        return 1
    }
    
    # Check all casks exist
    grep '^cask' "$brewfile" | cut -d'"' -f2 | while read cask; do
        brew info --cask "$cask" >/dev/null 2>&1 || {
            echo "Unknown cask: $cask"
        }
    done
}
```