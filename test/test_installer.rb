# frozen_string_literal: true

require "test_helper"
require "tmpdir"

class TestInstaller < Minitest::Test
  def setup
    @tmp_dir = Dir.mktmpdir
    @target_dir = File.join(@tmp_dir, ".claude", "commands")

    @installer = ClaudeCodeSlashCommands::Installer.new(
      commands_target: Pathname.new(@target_dir),
      repo: "test/test-repo"
    )
  end

  def teardown
    FileUtils.rm_rf(@tmp_dir)
  end

  def test_installs_command_files_from_github
    # Mock GitHub API response for listing commands
    commands_response = [
      {"name" => "test.md", "type" => "file", "download_path" => "test/test-repo/test.md"},
      {"name" => "other.md", "type" => "file", "download_path" => "test/test-repo/other.md"}
    ]

    # Mock file content
    command_content = "# Test command"

    # Stub the GitHub API calls
    success_status = stub(success?: true)
    Open3.stubs(:capture3).with("gh", "api", "repos/test/test-repo/contents/commands")
          .returns([JSON.generate(commands_response), "", success_status])

    Open3.stubs(:capture3).with("gh", "api", "test/test-repo/test.md")
          .returns([command_content, "", success_status])

    Open3.stubs(:capture3).with("gh", "api", "test/test-repo/other.md")
          .returns([command_content, "", success_status])

    @installer.install

    assert File.exist?(File.join(@target_dir, "test.md"))
    assert File.exist?(File.join(@target_dir, "other.md"))
    assert_equal command_content, File.read(File.join(@target_dir, "test.md"))
    assert_equal command_content, File.read(File.join(@target_dir, "other.md"))
  end

  def test_creates_target_directory
    commands_response = [
      {"name" => "test.md", "type" => "file", "download_path" => "test/test-repo/test.md"}
    ]

    Open3.stubs(:capture3).with("gh", "api", "repos/test/test-repo/contents/commands")
          .returns([JSON.generate(commands_response), "", stub(success?: true)])

    Open3.stubs(:capture3).with("gh", "api", "test/test-repo/test.md")
          .returns(["# Test", "", stub(success?: true)])

    refute Dir.exist?(@target_dir)
    @installer.install
    assert Dir.exist?(@target_dir)
  end

  def test_handles_no_command_files
    # Mock empty response from GitHub
    Open3.stubs(:capture3).with("gh", "api", "repos/test/test-repo/contents/commands")
          .returns([JSON.generate([]), "", stub(success?: true)])

    output = capture_io { @installer.install }

    assert_match(/No command files found/, output.first)
  end

  def test_filters_only_markdown_files
    # Mock GitHub API response with mixed file types
    commands_response = [
      {"name" => "test.md", "type" => "file", "download_path" => "test/test-repo/test.md"},
      {"name" => "readme.txt", "type" => "file", "download_path" => "test/test-repo/readme.txt"},
      {"name" => "other.md", "type" => "file", "download_path" => "test/test-repo/other.md"}
    ]

    Open3.stubs(:capture3).with("gh", "api", "repos/test/test-repo/contents/commands")
          .returns([JSON.generate(commands_response), "", stub(success?: true)])

    Open3.stubs(:capture3).with("gh", "api", "test/test-repo/test.md")
          .returns(["# Test", "", stub(success?: true)])

    Open3.stubs(:capture3).with("gh", "api", "test/test-repo/other.md")
          .returns(["# Other", "", stub(success?: true)])

    @installer.install

    assert File.exist?(File.join(@target_dir, "test.md"))
    assert File.exist?(File.join(@target_dir, "other.md"))
    refute File.exist?(File.join(@target_dir, "readme.txt"))
  end

  def test_skips_identical_existing_files
    # Create existing file with same content
    FileUtils.mkdir_p(@target_dir)
    File.write(File.join(@target_dir, "test.md"), "# Test command")

    commands_response = [
      {"name" => "test.md", "type" => "file", "download_path" => "test/test-repo/test.md"}
    ]

    Open3.stubs(:capture3).with("gh", "api", "repos/test/test-repo/contents/commands")
          .returns([JSON.generate(commands_response), "", stub(success?: true)])

    Open3.stubs(:capture3).with("gh", "api", "test/test-repo/test.md")
          .returns(["# Test command", "", stub(success?: true)])

    output = capture_io { @installer.install }

    assert_match(/already exists and is identical/, output.first)
  end

  def test_handles_github_api_failure_for_listing_commands
    # Mock failed GitHub API call
    Open3.stubs(:capture3).with("gh", "api", "repos/test/test-repo/contents/commands")
          .returns(["", "API rate limit exceeded", stub(success?: false)])

    assert_raises(SystemExit) do
      capture_io { @installer.install }
    end
  end

  def test_handles_github_api_failure_for_command_content
    commands_response = [
      {"name" => "test.md", "type" => "file", "download_path" => "test/test-repo/test.md"}
    ]

    Open3.stubs(:capture3).with("gh", "api", "repos/test/test-repo/contents/commands")
          .returns([JSON.generate(commands_response), "", stub(success?: true)])

    # Mock failed command content fetch
    Open3.stubs(:capture3).with("gh", "api", "test/test-repo/test.md")
          .returns(["", "File not found", stub(success?: false)])

    assert_raises(SystemExit) do
      capture_io { @installer.install }
    end
  end

  def test_handles_invalid_json_response
    # Mock invalid JSON response
    Open3.stubs(:capture3).with("gh", "api", "repos/test/test-repo/contents/commands")
          .returns(["invalid json", "", stub(success?: true)])

    assert_raises(SystemExit) do
      capture_io { @installer.install }
    end
  end
end
