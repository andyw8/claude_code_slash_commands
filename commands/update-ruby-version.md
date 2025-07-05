---
description: Update the Ruby version
---

Begin by ensuring the tests are passing. Take a note of any deprecation notices.

Look up information about supported and EOL versions using https://endoflife.date/api/v1/products/ruby/

If the project is a gem, be sure to test against the minimum supported version in the `.gemspec`.

It's ok to drop support for EOL versions of Ruby.

Run the tests again and ensure they pass. If there are any new deprecation messages, let the user know.

## CI (GitHub Actions)

If this project is a gem, ensure the test matrix covers all supported minor releases, e.g. "3.1", "3.2", "3.3".
