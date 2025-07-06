---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), WebFetch(domain:rubygems.org)
description: Add rubocop
---
 Add `rubocop` to this repo by following these steps:                                       │

- Create a new branch
- Check what the latest release of rubocop is using https://rubygems.org/gems/rubocop/
- Add the latest release of the rubocop gem as a development dependency
- Commit
- If there is a `Rakefile`, configure the `rubocop` task
- If there is a default task, configure `rubocop` to run as part of that
- Commit
- Run rubocop
- If there are linting errors, run rubocop with the `--autocorrect` flag and commit
- If the CLI suggests that additional errors can be fixed unsafely then run with `--autocorrect-all` and commit
- If there are remaining linting errors, run rubocop with --auto-gen-config and commit.
- If there is a CI configuration such as GitHub Actions, configure it to run rubocop as part of CI. The linting should be in a separate job from the tests.
- Commit
