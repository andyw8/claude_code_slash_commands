# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Testing and Development
- `rake test` - Run the test suite using Minitest
- `bundle exec rake test` - Run tests with bundler
- `rake standard` - Run StandardRB linter for code formatting
- `rake standard:fix` - Auto-fix StandardRB formatting issues
- `rake` - Run default task (both tests and linting)

### Gem Development
- `bundle exec rake install` - Install gem locally for testing
- `bundle exec rake release` - Create git tag and push to RubyGems
- `bundle exec rake build` - Build the gem file
- `bin/setup` - Install dependencies after checkout
- `bin/console` - Start interactive console with gem loaded

### CLI Usage
- `claude_code_slash_commands install` - Install commands to ~/.claude/commands from GitHub
- `claude_code_slash_commands install --local` - Install commands from local commands/ directory
- `claude_code_slash_commands help` - Show help message

## Architecture

This is a Ruby gem that distributes slash commands for Claude Code. The main components are:

### Core Structure
- `ClaudeCodeSlashCommands::CLI` - Command-line interface handler that processes user commands
- `ClaudeCodeSlashCommands::Installer` - Handles downloading and installing command files from GitHub to `~/.claude/commands`
- `commands/` directory - Contains the actual slash command markdown files that get distributed

### Key Features
- **GitHub Integration**: Uses `gh` CLI to fetch command files directly from the repository
- **Smart Installation**: Compares file contents to avoid unnecessary overwrites, prompts for confirmation when files differ
- **Command Format**: Slash commands are markdown files with optional YAML frontmatter for metadata

### Dependencies
- Requires GitHub CLI (`gh`) to be installed and configured
- Uses StandardRB for code formatting
- Minitest for testing framework
- Mocha for test mocking

### Command File Structure
Slash commands are stored as `.md` files in the `commands/` directory with this format:
```markdown
---
description: Brief description of the command
allowed-tools: Bash(git status:*)
---

Command prompt content goes here
```

The installer fetches these files from GitHub and copies them to the user's `~/.claude/commands` directory.
