#!/bin/bash

echo "🚀 Starting publish script..."

# Ensure we are in the project root (optional check, assuming ran from root)

# Step 1: Git Add
echo "--------------------------------"
echo "Step 1: git add ."
git add .
if [ $? -eq 0 ]; then
    echo "✅ git add complete"
else
    echo "❌ git add failed"
    exit 1
fi

# Step 2: Extract Version and Commit
echo "--------------------------------"
echo "Step 2: Checking version and committing"

if [ -f "android/version.json" ]; then
    # Extract version using awk to avoid jq dependency
    VERSION=$(awk -F '"' '/"version":/ {print $4}' android/version.json)
    
    if [ -n "$VERSION" ]; then
        echo "Found version: $VERSION"
        git commit -m "added new version $VERSION"
        
        if [ $? -eq 0 ]; then
            echo "✅ git commit complete"
        else
            echo "⚠️  git commit returned non-zero (no changes to commit?)"
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
echo "--------------------------------"
echo "Step 3: git push"
git push
if [ $? -eq 0 ]; then
    echo "✅ git push complete"
else
    echo "❌ git push failed"
    exit 1
fi

echo "--------------------------------"
echo "🎉 Script finished successfully"
