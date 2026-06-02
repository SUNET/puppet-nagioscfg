# Rakefile for puppet-lint and puppet-syntax
# Run:
#   bundle exec rake lint
#   bundle exec rake lint:fix
#   bundle exec rake syntax
#
# Lint check config (disabled checks) lives in .puppet-lint.rc so that the
# CLI, this Rakefile, the editor LSP, and `puppet-lint --fix` all share it.

require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

PuppetLint.configuration.with_filename = true

# `rake lint:fix` auto-corrects the fixable style issues (tabs, quoting,
# ${} interpolation, trailing whitespace) in place.
PuppetLint::RakeTask.new :'lint:fix' do |config|
  config.fix = true
end
