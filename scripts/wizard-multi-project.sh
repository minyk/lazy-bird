#!/bin/bash
# Lazy_Bird Wizard Multi-Project Enhancement Functions
# Phase 1.1: Add support for configuring multiple projects
# Source this file in wizard.sh for multi-project functionality

# Configure a single project interactively
# Sets global variables: PROJECT_ID, PROJECT_NAME, FRAMEWORK_TYPE, PROJECT_PATH, etc.
# Returns 0 on success, 1 if user cancels
configure_single_project() {
    local project_num="$1"
    local is_first_project="${2:-false}"

    if [ "$is_first_project" = "true" ]; then
        echo ""
        section "Project Configuration"
        echo "Let's configure your first project..."
    else
        echo ""
        section "Configure Project #$project_num"
    fi
    echo ""

    # Project ID (required, must be unique)
    while true; do
        read -p "❓ Project ID (alphanumeric with dashes, e.g., my-game): " PROJECT_ID
        PROJECT_ID=$(echo "$PROJECT_ID" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g')

        if [ -z "$PROJECT_ID" ]; then
            error "Project ID cannot be empty"
            continue
        fi

        # Check if ID already exists in PROJECTS array
        local id_exists=false
        for proj in "${PROJECTS[@]}"; do
            local existing_id=$(echo "$proj" | cut -d: -f1)
            if [ "$existing_id" = "$PROJECT_ID" ]; then
                error "Project ID '$PROJECT_ID' already exists. Choose a different ID."
                id_exists=true
                break
            fi
        done

        if [ "$id_exists" = "false" ]; then
            success "Project ID: $PROJECT_ID"
            break
        fi
    done

    # Project Name
    read -p "❓ Project name (display name): " PROJECT_NAME
    if [ -z "$PROJECT_NAME" ]; then
        PROJECT_NAME="$PROJECT_ID"
    fi
    success "Project name: $PROJECT_NAME"
    echo ""

    # Project Type Category (reuse wizard.sh logic)
    echo "❓ What type of project?"
    echo "  1) Game Engine"
    echo "  2) Backend Framework"
    echo "  3) Frontend Framework"
    echo "  4) Programming Language (General)"
    echo "  5) Custom (manual configuration)"
    read -p "Select [1-5]: " PROJECT_CATEGORY_CHOICE

    # Framework selection (simplified - full logic is in wizard.sh)
    FRAMEWORK_TYPE=""
    TEST_COMMAND="null"
    BUILD_COMMAND="null"
    LINT_COMMAND="null"
    FORMAT_COMMAND="null"

    case "$PROJECT_CATEGORY_CHOICE" in
        1) # Game Engine
            echo ""
            echo "❓ Which game engine?"
            echo "  1) Godot"
            echo "  2) Unity"
            echo "  3) Bevy (Rust)"
            echo "  4) Other"
            read -p "Select [1-4]: " FRAMEWORK_CHOICE

            case "$FRAMEWORK_CHOICE" in
                1) FRAMEWORK_TYPE="godot" ;;
                2) FRAMEWORK_TYPE="unity" ;;
                3) FRAMEWORK_TYPE="bevy" ;;
                *) FRAMEWORK_TYPE="custom" ;;
            esac
            ;;
        2) # Backend
            echo ""
            echo "❓ Which backend framework?"
            echo "  1) Django"
            echo "  2) Flask"
            echo "  3) FastAPI"
            echo "  4) Express"
            echo "  5) Other"
            read -p "Select [1-5]: " FRAMEWORK_CHOICE

            case "$FRAMEWORK_CHOICE" in
                1) FRAMEWORK_TYPE="django" ;;
                2) FRAMEWORK_TYPE="flask" ;;
                3) FRAMEWORK_TYPE="fastapi" ;;
                4) FRAMEWORK_TYPE="express" ;;
                *) FRAMEWORK_TYPE="custom" ;;
            esac
            ;;
        3) # Frontend
            echo ""
            echo "❓ Which frontend framework?"
            echo "  1) React"
            echo "  2) Vue"
            echo "  3) Angular"
            echo "  4) Svelte"
            echo "  5) Other"
            read -p "Select [1-5]: " FRAMEWORK_CHOICE

            case "$FRAMEWORK_CHOICE" in
                1) FRAMEWORK_TYPE="react" ;;
                2) FRAMEWORK_TYPE="vue" ;;
                3) FRAMEWORK_TYPE="angular" ;;
                4) FRAMEWORK_TYPE="svelte" ;;
                *) FRAMEWORK_TYPE="custom" ;;
            esac
            ;;
        4) # Language
            echo ""
            echo "❓ Which programming language?"
            echo "  1) Python"
            echo "  2) Rust"
            echo "  3) Go"
            echo "  4) Node.js"
            echo "  5) Other"
            read -p "Select [1-5]: " FRAMEWORK_CHOICE

            case "$FRAMEWORK_CHOICE" in
                1) FRAMEWORK_TYPE="python" ;;
                2) FRAMEWORK_TYPE="rust" ;;
                3) FRAMEWORK_TYPE="go" ;;
                4) FRAMEWORK_TYPE="nodejs" ;;
                *) FRAMEWORK_TYPE="custom" ;;
            esac
            ;;
        *)
            FRAMEWORK_TYPE="custom"
            ;;
    esac

    # Load framework preset if available
    if [ "$FRAMEWORK_TYPE" != "custom" ] && [ -f "config/framework-presets.yml" ]; then
        # Try to load preset (simplified)
        case "$FRAMEWORK_TYPE" in
            godot)
                TEST_COMMAND="godot --headless -s addons/gdUnit4/bin/GdUnitCmdTool.gd --test-suite all"
                ;;
            python|django|flask|fastapi)
                TEST_COMMAND="pytest tests/"
                LINT_COMMAND="flake8 ."
                FORMAT_COMMAND="black ."
                ;;
            rust|bevy)
                TEST_COMMAND="cargo test --all"
                BUILD_COMMAND="cargo build --release"
                LINT_COMMAND="cargo clippy"
                FORMAT_COMMAND="cargo fmt"
                ;;
            nodejs|react|vue|express)
                TEST_COMMAND="npm test"
                BUILD_COMMAND="npm run build"
                LINT_COMMAND="npm run lint"
                ;;
        esac
    fi

    success "Project type: $FRAMEWORK_TYPE"
    echo ""

    # Project Path
    while true; do
        read -p "❓ Project path (absolute): " PROJECT_PATH
        PROJECT_PATH="${PROJECT_PATH/#\~/$HOME}"

        if [ ! -d "$PROJECT_PATH" ]; then
            error "Directory does not exist: $PROJECT_PATH"
            read -p "Try again? [Y/n]: " retry
            if [[ ! $retry =~ ^[Yy]$ ]] && [[ ! -z $retry ]]; then
                return 1
            fi
            continue
        fi

        if [ ! -d "$PROJECT_PATH/.git" ]; then
            warning "Not a git repository: $PROJECT_PATH"
            read -p "Continue anyway? [y/N]: " continue_anyway
            if [[ ! $continue_anyway =~ ^[Yy]$ ]]; then
                continue
            fi
        fi

        success "Project path: $PROJECT_PATH"
        break
    done
    echo ""

    # Repository URL
    read -p "❓ Repository URL: " REPOSITORY
    success "Repository: $REPOSITORY"
    echo ""

    # Git Platform
    echo "❓ Git platform:"
    echo "  1) GitHub"
    echo "  2) GitLab"
    read -p "Select [1-2]: " GIT_PLATFORM_CHOICE

    case "$GIT_PLATFORM_CHOICE" in
        2) GIT_PLATFORM="gitlab" ;;
        *) GIT_PLATFORM="github" ;;
    esac

    success "Platform: $GIT_PLATFORM"
    echo ""

    # Test Command (allow override)
    if [ "$TEST_COMMAND" != "null" ]; then
        echo "❓ Test command (press Enter to use preset):"
        echo "   Preset: $TEST_COMMAND"
        read -p "Override: " TEST_OVERRIDE
        if [ -n "$TEST_OVERRIDE" ]; then
            TEST_COMMAND="$TEST_OVERRIDE"
        fi
    else
        read -p "❓ Test command: " TEST_COMMAND
        if [ -z "$TEST_COMMAND" ]; then
            TEST_COMMAND="null"
        fi
    fi
    success "Test: $TEST_COMMAND"

    return 0
}

# Display summary of all configured projects
display_project_summary() {
    echo ""
    section "Project Summary"
    echo "You have configured ${#PROJECTS[@]} project(s):"
    echo ""

    local i=1
    for proj in "${PROJECTS[@]}"; do
        IFS=':' read -r id name type path repo platform test_cmd build_cmd lint_cmd <<< "$proj"
        echo "${i}. [$id] $name ($type)"
        echo "   Path: $path"
        echo "   Repository: $repo ($platform)"
        echo "   Test: $test_cmd"
        [ "$build_cmd" != "null" ] && echo "   Build: $build_cmd"
        [ "$lint_cmd" != "null" ] && echo "   Lint: $lint_cmd"
        echo ""
        i=$((i + 1))
    done
}

# Generate Phase 1.1 config with projects array
generate_multiproject_config() {
    local config_file="$HOME/.config/lazy_birtd/config.yml"
    local max_ram="${1:-10}"
    local phase="${2:-1}"
    local notifications_enabled="${3:-false}"
    local ntfy_topic="${4:-}"

    info "Generating Phase 1.1 multi-project configuration..."

    cat > "$config_file" <<EOF
# Lazy_Bird Configuration (Phase 1.1 Multi-Project)
# Generated by wizard on $(date)

# ============================================================================
# MULTI-PROJECT CONFIGURATION
# ============================================================================
projects:
EOF

    # Add each project
    for proj in "${PROJECTS[@]}"; do
        IFS=':' read -r id name type path repo platform test_cmd build_cmd lint_cmd <<< "$proj"

        cat >> "$config_file" <<EOF
  - id: "$id"
    name: "$name"
    type: $type
    path: $path
    repository: $repository
    git_platform: $platform
    test_command: "$test_cmd"
    build_command: $build_cmd
    lint_command: $lint_cmd
    format_command: null
    enabled: true

EOF
    done

    # Add system configuration
    cat >> "$config_file" <<EOF
# ============================================================================
# SYSTEM CONFIGURATION
# ============================================================================
poll_interval_seconds: 60

phase: $phase
max_concurrent_agents: 1
memory_limit_gb: $max_ram

# Retry configuration
retry:
  max_attempts: 3
  max_cost_per_task_usd: 5.0
  daily_budget_limit_usd: 50.0

# Notifications
notifications:
  enabled: $notifications_enabled
  method: $([ "$notifications_enabled" = "true" ] && echo "ntfy" || echo "none")
  topic: "$ntfy_topic"
EOF

    success "Configuration saved to $config_file"
}

# Add a project to existing configuration
add_project_to_config() {
    local config_file="$HOME/.config/lazy_birtd/config.yml"

    if [ ! -f "$config_file" ]; then
        error "No existing configuration found. Run ./wizard.sh first."
        return 1
    fi

    info "Adding project to existing configuration..."

    # Configure new project
    if ! configure_single_project 1 false; then
        warning "Project configuration cancelled"
        return 1
    fi

    # Use project-manager.py to add the project
    if [ -f "scripts/project-manager.py" ]; then
        python3 scripts/project-manager.py add \
            --id "$PROJECT_ID" \
            --name "$PROJECT_NAME" \
            --type "$FRAMEWORK_TYPE" \
            --path "$PROJECT_PATH" \
            --repository "$REPOSITORY" \
            --git-platform "$GIT_PLATFORM" \
            --test-command "$TEST_COMMAND" \
            ${BUILD_COMMAND:+--build-command "$BUILD_COMMAND"} \
            ${LINT_COMMAND:+--lint-command "$LINT_COMMAND"}

        if [ $? -eq 0 ]; then
            success "Project '$PROJECT_ID' added successfully!"
            info "Restart issue-watcher to monitor the new project:"
            info "  systemctl --user restart issue-watcher"
            return 0
        else
            error "Failed to add project"
            return 1
        fi
    else
        error "project-manager.py not found"
        return 1
    fi
}
