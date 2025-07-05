# frozen_string_literal: true

require "test_helper"

class TestCLI < Minitest::Test
  def test_install_command_without_local_flag
    installer_mock = mock
    installer_mock.expects(:install)

    ClaudeCodeSlashCommands::Installer.expects(:new).with(local: false).returns(installer_mock)

    ClaudeCodeSlashCommands::CLI.start(["install"])
  end

  def test_install_command_with_local_flag
    installer_mock = mock
    installer_mock.expects(:install)

    ClaudeCodeSlashCommands::Installer.expects(:new).with(local: true).returns(installer_mock)

    ClaudeCodeSlashCommands::CLI.start(["install", "--local"])
  end

  def test_help_command_shows_local_flag_option
    output = capture_io do
      ClaudeCodeSlashCommands::CLI.start(["help"])
    end

    assert_match(/--local/, output.first)
    assert_match(/Install from local commands/, output.first)
  end

  def test_help_command_shows_local_flag_example
    output = capture_io do
      ClaudeCodeSlashCommands::CLI.start(["help"])
    end

    assert_match(/claude_code_slash_commands install --local/, output.first)
  end

  def test_unknown_command_shows_help
    output = capture_io do
      assert_raises(SystemExit) do
        ClaudeCodeSlashCommands::CLI.start(["unknown"])
      end
    end

    assert_match(/Unknown command: unknown/, output.first)
    assert_match(/Usage:/, output.first)
  end
end
