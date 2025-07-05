# frozen_string_literal: true

require "fileutils"
require "pathname"
require "json"
require "open3"

module ClaudeCodeSlashCommands
  class Installer
    def initialize(commands_source: nil, commands_target: nil, repo: nil)
      @gem_root = Pathname.new(__dir__).parent.parent
      @commands_source = commands_source || @gem_root.join("commands")
      @commands_target = commands_target || Pathname.new(Dir.home).join(".claude", "commands")
      @repo = repo || "andyw8/claude_code_slash_commands"
    end

    def install
      ensure_target_directory

      commands = fetch_commands_from_github
      if commands.empty?
        puts "❌ No command files found to install"
        return
      end

      commands.each do |command|
        install_command_from_github(command)
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
      stdout, stderr, status = Open3.capture3("gh", "api", command["download_url"])
      
      unless status.success?
        raise "Failed to fetch command content for #{filename}: #{stderr}"
      end

      content = stdout

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
  end
end
