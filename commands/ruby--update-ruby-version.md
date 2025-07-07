---
description: Update to latest Ruby version
---
The goal is to update this project to use the latest Ruby version.

- Before starting, verify the tests are passing (make a note of any deprecations)
- Read https://www.ruby-lang.org/en/downloads/branches/ to check the latest Ruby release version.
- If it's not already available, install that Ruby version.
- Read https://www.ruby-lang.org/en/downloads/branches/ to check the latest Ruby release version.
- If a .ruby-version file exists, update it to the latest Ruby version, otherwise create it.
- Run `bundle install`.
- If any gems are not compatible with the latest Ruby version, try update them.
- Ensure the tests are still passing.
- If there any new deprecations, ask if the user you should fix them.
- Commit the changes.
