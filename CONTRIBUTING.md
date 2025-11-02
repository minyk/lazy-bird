# Contributing to Lazy_Bird

Thank you for your interest in contributing to Lazy_Bird! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Adding Framework Presets](#adding-framework-presets)
- [Testing](#testing)
- [Documentation](#documentation)

## Code of Conduct

This project and everyone participating in it is governed by the [Lazy_Bird Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce**
- **Expected vs actual behavior**
- **Environment details** (OS, Lazy_Bird version, framework, etc.)
- **Logs and error messages**
- **Screenshots** (if applicable)

**Use the bug report template when available.**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide detailed description** of the suggested enhancement
- **Explain why this enhancement would be useful**
- **List examples** of how it would be used
- **Mention alternatives** you've considered

### Adding Framework Support

Want to add support for a new framework? Great!

1. **Check if it's already requested** in Issues or Discussions
2. **Create an issue** describing the framework
3. **Add a preset** to `config/framework-presets.yml`
4. **Test thoroughly** with a real project
5. **Update documentation**
6. **Submit a PR** (see below)

See [Adding Framework Presets](#adding-framework-presets) for details.

### Improving Documentation

Documentation improvements are always welcome!

- Fix typos or unclear instructions
- Add examples and use cases
- Improve existing guides
- Translate documentation
- Add framework-specific guides

## Development Setup

### Prerequisites

- Git 2.30+
- Bash 4.0+ (or compatible shell)
- Python 3.8+ (for testing)
- Claude Code CLI (optional, for testing)
- Your framework's tools (Godot, Rust, Node.js, etc.)

### Setup Steps

```bash
# 1. Fork the repository on GitHub

# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/lazy-bird.git
cd lazy-bird

# 3. Add upstream remote
git remote add upstream https://github.com/yusufkaraaslan/lazy-bird.git

# 4. Create a branch for your changes
git checkout -b feature/your-feature-name

# 5. Make your changes

# 6. Test your changes
./tests/phase0/validate-all.sh /path/to/test-project --type <framework>

# 7. Commit and push
git add .
git commit -m "Description of changes"
git push origin feature/your-feature-name

# 8. Create a Pull Request on GitHub
```

## Pull Request Process

### Before Submitting

1. **Test your changes** thoroughly
2. **Update documentation** if needed
3. **Follow coding standards** (see below)
4. **Ensure tests pass** (if applicable)
5. **Update CHANGELOG** (if significant change)
6. **Rebase on latest main** if needed

### PR Requirements

- **Clear title** describing the change
- **Detailed description** of what and why
- **Link to related issues** (`Fixes #123`, `Closes #456`)
- **List of changes** (bullet points)
- **Testing done** (how you verified it works)
- **Screenshots** (for UI changes)

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update
- [ ] Framework preset addition

## Related Issues
Fixes #(issue number)

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
- Test scenario 1
- Test scenario 2

## Checklist
- [ ] Code follows project style
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] All tests passing
- [ ] Commit messages are clear
```

### Review Process

1. Maintainers will review your PR
2. Address any requested changes
3. Once approved, maintainers will merge
4. Your contribution will be in the next release!

## Coding Standards

### Bash Scripts

```bash
#!/bin/bash
# Script description

set -euo pipefail  # Always include this

# Use meaningful variable names
PROJECT_PATH="/path/to/project"

# Add comments for complex logic
# This function does X because Y
function do_something() {
    local input="$1"
    # Function body
}

# Error handling
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file not found" >&2
    exit 1
fi
```

### Python Scripts

```python
"""Module description."""

import sys
from typing import List, Dict


def function_name(param: str) -> bool:
    """
    Function description.

    Args:
        param: Parameter description

    Returns:
        Return value description
    """
    # Implementation
    pass
```

### YAML Files

```yaml
# Comments explaining the section
framework_name:
  name: "Display Name"
  description: "Brief description"
  test_command: "command to run tests"
  build_command: null  # or actual command
  lint_command: null   # optional
```

## Adding Framework Presets

### Step 1: Research

1. Identify the framework's standard test/build commands
2. Check official documentation
3. Test commands in a real project
4. Note any special requirements or flags

### Step 2: Create Preset

Edit `config/framework-presets.yml`:

```yaml
your_framework:
  name: "Framework Name"
  description: "Brief description (e.g., 'Python web framework')"
  test_command: "command to run tests"
  build_command: "command to build (or null)"
  lint_command: "command to lint (or null)"
  format_command: "command to format (or null)"
  file_extensions: [".ext1", ".ext2"]
  ignore_patterns: ["pattern1/", "pattern2/"]
  docs_url: "https://framework-website.com/"
```

### Step 3: Test

```bash
# Test with a real project
./tests/phase0/validate-all.sh /path/to/test-project --type your_framework

# Test wizard integration
./wizard.sh
# Select your framework
# Verify config generated correctly
```

### Step 4: Document

Add your framework to:
- `README.md` - Framework list and examples
- `Docs/` - Framework-specific guide (optional)
- `CHANGELOG.md` - Note the addition

### Step 5: Submit PR

Create a PR with:
- Framework preset added
- Tests passing
- Documentation updated
- Example project (optional but helpful)

## Testing

### Manual Testing

```bash
# Phase 0 validation
./tests/phase0/validate-all.sh /path/to/project --type framework

# Full workflow test
# 1. Set up config
# 2. Create test issue
# 3. Verify automation works
# 4. Check PR creation
```

### Automated Testing

If adding test scripts:
- Place in `tests/` directory
- Follow existing test patterns
- Include positive and negative test cases
- Test error handling

## Documentation

### Documentation Standards

- **Clear and concise**: Avoid jargon
- **Examples included**: Show, don't just tell
- **Up to date**: Update docs with code changes
- **Well structured**: Use headers and sections
- **Screenshots**: For UI or visual changes

### Documentation Locations

- `README.md` - Main documentation
- `CLAUDE.md` - Developer guide
- `Docs/Design/` - Architecture and design docs
- Code comments - Complex logic explanation

### Writing Style

- Use **present tense** ("Lazy_Bird creates..." not "will create...")
- Use **active voice** ("Run the command" not "The command should be run")
- Be **specific** ("Set test_command to 'pytest'" not "Configure testing")
- Add **examples** for every major feature

## Questions?

- **Discussions**: https://github.com/yusufkaraaslan/lazy-bird/discussions
- **Issues**: https://github.com/yusufkaraaslan/lazy-bird/issues
- **Email**: Check GitHub profile for contact info

## Recognition

Contributors are recognized in:
- GitHub contributors page
- Release notes (for significant contributions)
- Special thanks in major releases

## Thank You!

Every contribution, no matter how small, is valuable and appreciated. Thank you for helping make Lazy_Bird better!

---

🤖 Built with [Claude Code](https://claude.com/claude-code)
