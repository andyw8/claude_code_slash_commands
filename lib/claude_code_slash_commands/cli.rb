# frozen_string_literal: true

require_relative "installer"

module ClaudeCodeSlashCommands
  class CLI
    def self.start(args)
      new(args).run
    end

    def initialize(args)
      @args = args
    end

    def run
      case @args.first
      when "install"
        local = @args.include?("--local")
        Installer.new(local: local).install
      when "help", "-h", "--help", nil
        show_help
      else
        puts "Unknown command: #{@args.first}"
        show_help
        exit(1)
      end
    end

    private

    def show_help
      puts <<~HELP
        Usage: claude_code_slash_commands <command> [options]

        Commands:
          install    Install slash commands to ~/.claude/commands
          help       Show this help message

        Options:
          --local    Install from local commands/ directory instead of GitHub

        Examples:
          claude_code_slash_commands install
          claude_code_slash_commands install --local
          claude_code_slash_commands help
      HELP
    end
  end
end
