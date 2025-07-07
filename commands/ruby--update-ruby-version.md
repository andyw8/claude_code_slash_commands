---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), WebFetch(domain:rubygems.org), Bash(ruby --version),Bash(bundle exec rake:*), WebFetch(domain:www.ruby-lang.org), Bash(bundle install:*), Bash(git add:*), Bash(git commit:*)
description: Update to latest Ruby version

---
The goal is to update this project to use the latest Ruby version.

- Before starting, verify the tests are passing (make a note of any deprecations)
- Read https://www.ruby-lang.org/en/downloads/branches/ to check the latest Ruby release version.
- If it's not already available, install that Ruby version. Determine which version manager is in use. If there seems to be more than one, prompt the user for which to use.
- Read https://www.ruby-lang.org/en/downloads/branches/ to check the latest Ruby release version.
- If a .ruby-version file exists, update it to the latest Ruby version, otherwise create it.
- Run `bundle install`.
- If any gems are not compatible with the latest Ruby version, try update them.
- Ensure the tests are still passing.
- If there any new deprecations, ask if the user you should fix them.
- Commit the changes.
