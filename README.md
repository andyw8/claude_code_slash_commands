# claude_code_slash_commands

This gem is intended to distribute [slash commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands) for [Claude Code](https://www.anthropic.com/claude-code).

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add claude_code_slash_commands
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install claude_code_slash_commands
```

## Usage

This gem provides a tool to distribute custom slash commands for Claude Code.

### Installing Commands

To install the included slash commands to your `~/.claude/commands` directory:

```bash
claude_code_slash_commands install
```

This will:
- Create `~/.claude/commands` directory if it doesn't exist
- Copy all command files from the `commands/` directory on GitHub to your local `~/.claude/commands` directory.
- Ask for confirmation before overwriting existing commands
- Skip files that are already identical

### Available Commands

- `hello_world.md` - A simple example command that demonstrates the slash command format

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andyw8/claude_code_slash_commands.

### Adding Your Own Commands

To add your own commands to this gem:

1. Create `.md` files in the `commands/` directory
2. Use YAML frontmatter for metadata (optional)
3. Write the command prompt in the file content

Example command format:
```markdown
---
description: Brief description of the command
allowed-tools: Bash(git status:*)
---

Your command prompt goes here. This text will be used as the instruction
when the slash command is invoked.
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
