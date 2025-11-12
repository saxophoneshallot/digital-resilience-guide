#!/usr/bin/env bash
#
# setup_anonymous_repo.sh
#
# Configures a git repository for anonymous publishing
# Prevents accidental identity leaks in commits
#
# Usage:
#   ./scripts/setup_anonymous_repo.sh
#
# This script:
# - Sets anonymous git identity (local to this repo)
# - Configures git to prevent common identity leaks
# - Tests the configuration

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default anonymous identity
DEFAULT_NAME="Digital Resilience Project"
DEFAULT_EMAIL="noreply@example.com"

echo "=========================================="
echo "Anonymous Git Repository Setup"
echo "=========================================="
echo

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    echo "Run this script from the root of your git repository"
    exit 1
fi

# Check if repo already has commits with personal identity
COMMIT_COUNT=$(git rev-list --all --count 2>/dev/null || echo "0")
if [ "$COMMIT_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}Warning: Repository already has $COMMIT_COUNT commits${NC}"
    echo "This script sets up anonymous identity for FUTURE commits only"
    echo "Existing commits will retain their current author information"
    echo
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted"
        exit 0
    fi
fi

# Prompt for anonymous identity
echo "Configure Anonymous Identity"
echo "----------------------------"
echo "This identity will be used for all commits in this repository."
echo "Common choices:"
echo "  - 'Digital Resilience Project' <noreply@example.com>"
echo "  - 'Anonymous Contributor' <anonymous@example.com>"
echo "  - Use GitHub's noreply email: <username+username@users.noreply.github.com>"
echo

read -p "Git user name [$DEFAULT_NAME]: " GIT_NAME
GIT_NAME=${GIT_NAME:-$DEFAULT_NAME}

read -p "Git email [$DEFAULT_EMAIL]: " GIT_EMAIL
GIT_EMAIL=${GIT_EMAIL:-$DEFAULT_EMAIL}

echo
echo "Setting git identity (local to this repository):"
echo "  user.name  = $GIT_NAME"
echo "  user.email = $GIT_EMAIL"
echo

# Configure git identity (local to this repo only)
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

# Verify configuration
CONFIGURED_NAME=$(git config user.name)
CONFIGURED_EMAIL=$(git config user.email)

if [ "$CONFIGURED_NAME" = "$GIT_NAME" ] && [ "$CONFIGURED_EMAIL" = "$GIT_EMAIL" ]; then
    echo -e "${GREEN}✓ Git identity configured${NC}"
else
    echo -e "${RED}✗ Failed to configure git identity${NC}"
    exit 1
fi

# Additional git configuration for privacy
echo
echo "Configuring additional privacy settings..."

# Disable git from guessing user identity
git config user.useConfigOnly true

# Disable commit.gpgsign if set globally (optional, user can re-enable locally)
# Uncomment if you want to disable GPG signing for anonymity
# git config commit.gpgsign false

echo -e "${GREEN}✓ Privacy settings configured${NC}"

# Test configuration
echo
echo "=========================================="
echo "Configuration Summary"
echo "=========================================="
echo
echo "Git Identity (local to this repo):"
git config user.name
git config user.email
echo
echo "Global Git Identity (if set):"
git config --global user.name 2>/dev/null || echo "(not set)"
git config --global user.email 2>/dev/null || echo "(not set)"
echo

# Check for identity leaks
echo "Checking for potential identity leaks..."
echo

# Check if .git/config contains personal info
if grep -qi "$(whoami)" .git/config 2>/dev/null; then
    echo -e "${YELLOW}⚠ Warning: Your username appears in .git/config${NC}"
    echo "Review .git/config and remove personal information"
fi

# Check if any files contain personal email
PERSONAL_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
if [ -n "$PERSONAL_EMAIL" ]; then
    if grep -r "$PERSONAL_EMAIL" --exclude-dir=.git . 2>/dev/null | grep -v "setup_anonymous_repo.sh"; then
        echo -e "${YELLOW}⚠ Warning: Your personal email appears in repository files${NC}"
        echo "Review and remove personal information before committing"
    fi
fi

echo -e "${GREEN}✓ Identity leak check complete${NC}"
echo

# Instructions for next steps
echo "=========================================="
echo "Next Steps"
echo "=========================================="
echo
echo "1. Before your first commit, verify anonymous identity:"
echo "   git config user.name"
echo "   git config user.email"
echo
echo "2. Make a test commit:"
echo "   echo 'test' > test.txt"
echo "   git add test.txt"
echo "   git commit -m 'Test commit'"
echo
echo "3. Verify the commit uses anonymous identity:"
echo "   git log -1 --format='%an <%ae>'"
echo
echo "4. If correct, delete test commit:"
echo "   git reset --soft HEAD~1"
echo "   rm test.txt"
echo
echo "5. For GitHub anonymous publishing:"
echo "   - Create new GitHub account via VPN/Tor"
echo "   - Use anonymous email (ProtonMail or GitHub noreply)"
echo "   - Never link to this repo from your personal accounts"
echo "   - Always access GitHub via VPN/Tor for this repo"
echo
echo -e "${GREEN}Setup complete!${NC}"
echo
echo "⚠️  Remember: This only protects future commits."
echo "    Always verify your identity before each commit:"
echo "    git config user.email"
