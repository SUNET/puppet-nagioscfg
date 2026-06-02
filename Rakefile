# Rakefile for puppet-lint and puppet-syntax
# Run:
#   bundle exec rake lint
#   bundle exec rake syntax

require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

PuppetLint.configuration.with_filename = true
# Checkout dir is 'puppet-nagioscfg', not 'nagioscfg', so the autoloader
# layout check produces false positives. Disable it.
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.send('disable_80chars')
