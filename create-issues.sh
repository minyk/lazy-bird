#!/bin/bash
# Create initial GitHub issues for Lazy_Bird implementation
# Run this after setting up labels and milestones

set -euo pipefail

echo "🦜 Creating Lazy_Bird implementation issues..."
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) not found"
    echo "Install from: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub"
    echo "Run: gh auth login"
    exit 1
fi

echo "✓ GitHub CLI ready"
echo ""

# Phase 0 Issues

echo "Creating Phase 0 issues..."

gh issue create \
  --title "Implement validate-claude.sh" \
  --body "## Description
Implement the Claude Code CLI validation script that tests all required functionality.

## Tasks
- [ ] Test \`claude --version\` works
- [ ] Test \`-p\` flag for prompts
- [ ] Test \`--allowedTools\` flag
- [ ] Test \`--dangerously-skip-permissions\` flag (in container)
- [ ] Test file modification capability
- [ ] Test directory handling
- [ ] Test output parsing
- [ ] Create comprehensive test suite

## Acceptance Criteria
- [ ] Script runs without errors
- [ ] All 8 tests pass on valid setup
- [ ] Clear error messages for failures
- [ ] Exit codes: 0 (success), 1 (failure)
- [ ] Documented in scripts/validate-claude.sh

## References
- Design: Docs/Design/phase0-validation.md
- Existing stub: scripts/validate-claude.sh" \
  --label "phase-0: validation,type: feature,priority: critical,component: validation" \
  --milestone "Phase 0: Validation Ready"

echo "✓ Issue 1: validate-claude.sh"

gh issue create \
  --title "Implement validate-godot.sh" \
  --body "## Description
Implement Godot + gdUnit4 validation script.

## Tasks
- [ ] Check Godot executable exists
- [ ] Verify Godot 4.x version
- [ ] Test headless mode (\`--headless --quit\`)
- [ ] Test project loading (\`--check-only\`)
- [ ] Check gdUnit4 installation
- [ ] Test gdUnit4 CLI tool
- [ ] Create sample test file
- [ ] Run sample test to verify

## Acceptance Criteria
- [ ] Script accepts project path argument
- [ ] All 8 tests pass on valid setup
- [ ] Installs gdUnit4 if missing (with confirmation)
- [ ] Clear error messages
- [ ] Documented in scripts/validate-godot.sh

## References
- Design: Docs/Design/phase0-validation.md
- Existing stub: scripts/validate-godot.sh" \
  --label "phase-0: validation,type: feature,priority: critical,component: validation" \
  --milestone "Phase 0: Validation Ready"

echo "✓ Issue 2: validate-godot.sh"

gh issue create \
  --title "Implement test-worktree.sh" \
  --body "## Description
Implement git worktree validation for multi-agent isolation.

## Tasks
- [ ] Test git worktree command availability
- [ ] Create test worktree
- [ ] Test multiple concurrent worktrees
- [ ] Test worktree isolation (files don't cross)
- [ ] Test git operations in worktree
- [ ] Test worktree removal/cleanup
- [ ] Test /tmp directory permissions
- [ ] Stress test (3+ worktrees)

## Acceptance Criteria
- [ ] All 10 tests pass
- [ ] Proper cleanup (removes test worktrees)
- [ ] Works with /tmp directory
- [ ] Clear error messages
- [ ] Documented in scripts/test-worktree.sh

## References
- Design: Docs/Design/phase0-validation.md
- Existing stub: scripts/test-worktree.sh" \
  --label "phase-0: validation,type: feature,priority: high,component: validation" \
  --milestone "Phase 0: Validation Ready"

echo "✓ Issue 3: test-worktree.sh"

gh issue create \
  --title "Create validate-all.sh master script" \
  --body "## Description
Create master validation script that runs all Phase 0 tests.

## Tasks
- [ ] Create tests/phase0/ directory
- [ ] Create validate-all.sh script
- [ ] Call validate-claude.sh
- [ ] Call validate-godot.sh (with project path)
- [ ] Call test-worktree.sh (with project path)
- [ ] Generate summary report
- [ ] Exit with appropriate code
- [ ] Add to wizard.sh Phase 0 step

## Acceptance Criteria
- [ ] Runs all 3 validation scripts
- [ ] Accepts Godot project path argument
- [ ] Shows summary (X/Y tests passed)
- [ ] Clear PASS/FAIL indication
- [ ] Stops on critical failures
- [ ] Returns 0 only if all pass

## References
- Design: Docs/Design/phase0-validation.md
- Location: tests/phase0/validate-all.sh" \
  --label "phase-0: validation,type: feature,priority: high,component: validation" \
  --milestone "Phase 0: Validation Ready"

echo "✓ Issue 4: validate-all.sh"

echo ""
echo "Creating Phase 1 issues..."

gh issue create \
  --title "Implement issue-watcher.py" \
  --body "## Description
Implement GitHub/GitLab issue monitoring service.

## Tasks
- [ ] Create scripts/issue-watcher.py
- [ ] Implement GitHub API integration
- [ ] Implement GitLab API integration (optional)
- [ ] Poll for issues with \"ready\" label
- [ ] Change labels: ready → processing → automated
- [ ] Launch agent-runner.sh for each issue
- [ ] Error handling and logging
- [ ] Systemd service file

## Acceptance Criteria
- [ ] Polls every 60 seconds
- [ ] Detects new \"ready\" issues
- [ ] Launches agents correctly
- [ ] Handles API errors gracefully
- [ ] Logs to systemd journal
- [ ] Can run as systemd service

## References
- Design: Docs/Design/issue-workflow.md
- Spec: Docs/Design/wizard-complete-spec.md

## Dependencies
- Requires: Phase 0 complete
- Requires: API tokens configured" \
  --label "phase-1: core,type: feature,priority: critical,component: issue-watcher" \
  --milestone "Phase 1: Core Automation MVP"

echo "✓ Issue 5: issue-watcher.py"

gh issue create \
  --title "Implement agent-runner.sh" \
  --body "## Description
Implement the agent launcher that creates worktrees and runs Claude.

## Tasks
- [ ] Create scripts/agent-runner.sh
- [ ] Accept issue ID, title, body as arguments
- [ ] Create git worktree for task
- [ ] Run Claude Code with correct syntax
- [ ] Commit changes if any
- [ ] Push branch to remote
- [ ] Create PR via gh CLI
- [ ] Cleanup worktree on completion
- [ ] Error handling and logging

## Acceptance Criteria
- [ ] Creates isolated worktree in /tmp
- [ ] Uses correct Claude syntax: \`claude -p \"...\"\`
- [ ] Commits with proper message
- [ ] Creates PR if changes made
- [ ] Cleans up worktree always
- [ ] Logs all actions
- [ ] Returns proper exit codes

## References
- Design: Docs/Design/claude-cli-reference.md
- Example: Docs/Design/implementation-roadmap.md

## Dependencies
- Requires: Phase 0 complete
- Requires: GitHub CLI (gh) installed" \
  --label "phase-1: core,type: feature,priority: critical,component: agent-runner" \
  --milestone "Phase 1: Core Automation MVP"

echo "✓ Issue 6: agent-runner.sh"

gh issue create \
  --title "Complete wizard.sh implementation" \
  --body "## Description
Complete the wizard.sh implementation beyond the branding.

## Tasks
- [ ] Implement system detection
- [ ] Implement Phase 0 validation integration
- [ ] Implement 8 question flow
- [ ] Implement configuration file generation
- [ ] Implement secret storage setup
- [ ] Implement systemd service installation
- [ ] Implement --status command
- [ ] Implement --health command

## Acceptance Criteria
- [ ] Asks all 8 questions
- [ ] Runs Phase 0 validation
- [ ] Creates ~/.config/lazy_bird/
- [ ] Generates config.yml
- [ ] Installs systemd services
- [ ] Runs test task
- [ ] Shows clear success/failure

## References
- Design: Docs/Design/wizard-complete-spec.md
- Existing: wizard.sh (branding only)

## Dependencies
- Requires: Phase 0 scripts complete
- Requires: issue-watcher.py complete
- Requires: agent-runner.sh complete" \
  --label "phase-1: core,type: feature,priority: high,component: wizard" \
  --milestone "Phase 1: Core Automation MVP"

echo "✓ Issue 7: wizard.sh implementation"

echo ""
echo "✅ All issues created!"
echo ""
echo "Next steps:"
echo "1. Go to: https://github.com/yusufkaraaslan/lazy-bird/issues"
echo "2. Review the issues"
echo "3. Add them to your project board"
echo "4. Start with Issue #1!"
echo ""
echo "🦜 Happy building!"
