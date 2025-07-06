# frozen_string_literal: true

require_relative "lib/claude_code_slash_commands/version"

Gem::Specification.new do |spec|
  spec.name = "claude_code_slash_commands"
  spec.version = ClaudeCodeSlashCommands::VERSION
  spec.authors = ["Andy Waite"]
  spec.email = ["13400+andyw8@users.noreply.github.com"]

  spec.summary = "A tool for distributing Claude Code slash commands."
  spec.homepage = "https://github.com/andyw8/claude_code_slash_commands"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/andyw8/claude_code_slash_commands"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ .git .github appveyor Gemfile/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "base64"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
