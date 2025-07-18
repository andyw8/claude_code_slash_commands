# claude_code_slash_commands

This gem is for distributing Ruby-specific [custom slash commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands#custom-slash-commands) for [Claude Code](https://www.anthropic.com/claude-code).

## Prerequisites

The [GitHub CLI](https://cli.github.com) must be installed and configured. (It's used to fetch files from GitHub without running into rate limits).

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
- Create the `~/.claude/commands` directory if it doesn't exist
- Copy all command files from the `commands/` directory on GitHub to your local `~/.claude/commands` directory.
- Ask for confirmation before overwriting existing commands
- Skip files that are already identical

#### Local Installation

By default, commands will be fetched from the gem's GitHub repository. That means you'll always get the latest versions.

To install commands from the gem's `commands/` directory instead of GitHub:

```bash
claude_code_slash_commands install --local
```

This is useful for:
- Testing new commands during development
- Installing commands when you don't have internet access

### Available Commands

Check the `commands/` directory to see what is available.

### Safety

Note that some commands have `allowed-tools` already defined, so Claude Code will not prompt you.
I aim to restrict these to low risk tools such as git usage or web fetching, but you may wish to review before running.

### Using the Commands

In your Claude Code session, type `/ruby--`  and you will the list of available commands.

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
