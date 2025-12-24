#!/bin/bash

# Default to quiet mode
SHOW_LOGS=false

# Check for flag
for arg in "$@"; do
  if [ "$arg" == "--show-logs" ]; then
    SHOW_LOGS=true
    break
  fi
done

# Helper for logging (only prints if SHOW_LOGS is true)
log_info() {
    if [ "$SHOW_LOGS" = true ]; then
        echo "$@"
    fi
}

# Helper to run commands
run_cmd() {
    if [ "$SHOW_LOGS" = true ]; then
        "$@"
    else
        "$@" > /dev/null 2>&1
    fi
}

log_info "🚀 Starting publish script..."

# Step 1: Git Add
log_info "--------------------------------"
log_info "Step 1: git add ."
if run_cmd git add .; then
    echo "✅ git add complete"
else
    echo "❌ git add failed"
    exit 1
fi

# Step 2: Extract Version and Commit
log_info "--------------------------------"
log_info "Step 2: Checking version and committing"

if [ -f "android/version.json" ]; then
    VERSION=$(grep '"version":' android/version.json | awk -F ':' '{print $2}' | tr -d '", ')
    
    if [ -n "$VERSION" ]; then
        log_info "Found version: $VERSION"
        
        # Try to commit
        if run_cmd git commit -m "added new version $VERSION"; then
            echo "✅ git commit complete"
        else
            # If commit fails (e.g. no changes), we notify but don't exit script strictly, 
            # though usually we want to stop if we expected a commit. 
            # However, git push might still be useful if we had previous commits.
            # But typically this script is for a flow. 
            # I will show error.
            echo "❌ git commit failed (or nothing to commit)"
        fi
    else
        echo "❌ Could not extract version from android/version.json"
        exit 1
    fi
else
    echo "❌ file android/version.json not found"
    exit 1
fi

# Step 3: Git Push
log_info "--------------------------------"
log_info "Step 3: git push"
if run_cmd git push; then
    echo "✅ git push complete"
else
    echo "❌ git push failed"
    exit 1
fi

log_info "--------------------------------"
log_info "🎉 Script finished successfully"
