---
description: Configure a gem's CI pipeline using GitHub Actions
---
The goal is to create a CI workflow file that runs the gem's tests as well as any linting or other verificiation tasks.

- If no CI workflow file exists, create one, otherwise update the existing one.
- Read https://www.ruby-lang.org/en/downloads/branches/ to check the latest Ruby release version.
- Configure the CI matrix such that it covers the the minimum `required_ruby_version` in the `.gemspec`, as well as every minor release up to the latest Ruby version.
- Commit
