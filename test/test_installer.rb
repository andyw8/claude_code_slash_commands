# frozen_string_literal: true

require "test_helper"
require "tmpdir"

class TestInstaller < Minitest::Test
  def setup
    @tmp_dir = Dir.mktmpdir
    @commands_dir = File.join(@tmp_dir, "commands")
    @target_dir = File.join(@tmp_dir, ".claude", "commands")

    Dir.mkdir(@commands_dir)

    @installer = ClaudeCodeSlashCommands::Installer.new(
      commands_source: Pathname.new(@commands_dir),
      commands_target: Pathname.new(@target_dir)
    )
  end

  def teardown
    FileUtils.rm_rf(@tmp_dir)
  end

  def test_installs_command_files
    File.write(File.join(@commands_dir, "test.md"), "# Test command")

    @installer.install

    assert File.exist?(File.join(@target_dir, "test.md"))
    assert_equal "# Test command", File.read(File.join(@target_dir, "test.md"))
  end

  def test_creates_target_directory
    File.write(File.join(@commands_dir, "test.md"), "# Test command")

    refute Dir.exist?(@target_dir)
    @installer.install
    assert Dir.exist?(@target_dir)
  end

  def test_handles_no_command_files
    output = capture_io { @installer.install }

    assert_match(/No command files found/, output.first)
  end
end
