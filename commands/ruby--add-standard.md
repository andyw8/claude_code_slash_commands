---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), WebFetch(domain:rubygems.org)
description: Add standard
---
Add `standardrb` to this repo by following these steps:

- Create a new branch
- Check what the latest release of standard is using https://rubygems.org/gems/standard/
- Add the latest release of the standard gem as a development dependency
- Commit
- If there is a `Rakefile`, configure the `standard` task
- If there is a default task, configure `standard` to run as part of that
- Commit
- Run standard
- If there are linting errors, run standardrb with the `--fix` flag and commit
- If the CLI suggests that additional errors can be fixed unsafely then run with `--fix-unsafely` and commit
- If there are remaining linting errors, run standardrb with --generate-todo and commit.
- If there is a CI configuration such as GitHub Actions, configure it to run standard as part of CI. The linting should be in a separate job from the tests.
- Commit
