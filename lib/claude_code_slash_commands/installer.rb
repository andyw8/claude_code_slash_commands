# frozen_string_literal: true

require "fileutils"
require "pathname"
require "json"
require "open3"
require "base64"

module ClaudeCodeSlashCommands
  class Installer
    def initialize(commands_source: nil, commands_target: nil, repo: nil, local: false)
      @gem_root = Pathname.new(__dir__).parent.parent
      @commands_source = commands_source || @gem_root.join("commands")
      @commands_target = commands_target || Pathname.new(Dir.home).join(".claude", "commands")
      @repo = repo || "andyw8/claude_code_slash_commands"
      @local = local
    end

    def install
      ensure_target_directory

      if @local
        commands = fetch_commands_from_local
        if commands.empty?
          puts "❌ No command files found in local commands/ directory"
          return
        end

        commands.each do |command_file|
          install_command_from_local(command_file)
        end
      else
        commands = fetch_commands_from_github
        if commands.empty?
          puts "❌ No command files found to install"
          return
        end

        commands.each do |command|
          install_command_from_github(command)
        end
      end

      puts "✅ Installation complete!"
    rescue => e
      puts "❌ Installation failed: #{e.message}"
      exit(1)
    end

    private

    def ensure_target_directory
      FileUtils.mkdir_p(@commands_target)
    end

    def fetch_commands_from_github
      stdout, stderr, status = Open3.capture3("gh", "api", "repos/#{@repo}/contents/commands")

      unless status.success?
        raise "Failed to fetch commands from GitHub: #{stderr}"
      end

      contents = JSON.parse(stdout)
      contents.select { |item| item["type"] == "file" && item["name"].end_with?(".md") }
    end

    def install_command_from_github(command)
      filename = command["name"]
      target_file = @commands_target.join(filename)

      # Fetch the content of the command file
      stdout, stderr, status = Open3.capture3(
        "gh",
        "api",
        "repos/#{@repo}/contents/" + command["path"],
        "--jq",
        ".content"
      )

      unless status.success?
        raise "Failed to fetch command content for #{filename}: #{stderr}"
      end

      content = stdout
      content = Base64.decode64(stdout)

      if target_file.exist?
        if target_file.read == content
          puts "⏭️  #{filename} already exists and is identical"
          return
        end

        unless confirm_overwrite(filename)
          puts "⏭️  Skipping #{filename}"
          return
        end
      end

      target_file.write(content)
      puts "📄 Installed #{filename}"
    end

    def confirm_overwrite(filename)
      print "❓ #{filename} already exists. Overwrite? (y/N): "
      response = $stdin.gets.chomp.downcase
      response == "y" || response == "yes"
    end

    def fetch_commands_from_local
      return [] unless @commands_source.exist?

      @commands_source.glob("*.md").select(&:file?)
    end

    def install_command_from_local(command_file)
      filename = command_file.basename.to_s
      target_file = @commands_target.join(filename)

      content = command_file.read

      if target_file.exist?
        if target_file.read == content
          puts "⏭️  #{filename} already exists and is identical"
          return
        end

        unless confirm_overwrite(filename)
          puts "⏭️  Skipping #{filename}"
          return
        end
      end

      target_file.write(content)
      puts "📄 Installed #{filename}"
    end
  end
end
