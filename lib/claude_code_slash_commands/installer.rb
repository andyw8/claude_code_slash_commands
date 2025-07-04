# frozen_string_literal: true

require "fileutils"
require "pathname"

module ClaudeCodeSlashCommands
  class Installer
    def initialize
      @gem_root = Pathname.new(__dir__).parent.parent
      @commands_source = @gem_root.join("commands")
      @commands_target = Pathname.new(Dir.home).join(".claude", "commands")
    end

    def install
      ensure_target_directory
      
      if command_files.empty?
        puts "❌ No command files found to install"
        return
      end
      
      command_files.each do |file|
        install_command(file)
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

    def command_files
      @commands_source.glob("*.md")
    end

    def install_command(source_file)
      target_file = @commands_target.join(source_file.basename)
      
      if target_file.exist?
        if files_identical?(source_file, target_file)
          puts "⏭️  #{source_file.basename} already exists and is identical"
          return
        end
        
        unless confirm_overwrite(source_file.basename)
          puts "⏭️  Skipping #{source_file.basename}"
          return
        end
      end
      
      FileUtils.cp(source_file, target_file)
      puts "📄 Installed #{source_file.basename}"
    end

    def files_identical?(file1, file2)
      file1.read == file2.read
    end

    def confirm_overwrite(filename)
      print "❓ #{filename} already exists. Overwrite? (y/N): "
      response = $stdin.gets.chomp.downcase
      response == "y" || response == "yes"
    end
  end
end