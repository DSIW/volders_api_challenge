# Require this file for unit tests
ENV['HANAMI_ENV'] ||= 'test'

require_relative '../../config/environment'
Hanami.boot

# Make rack-test methods accessible
World(Rack::Test::Methods)

require_relative '../../spec/support/helper'
