# frozen_string_literal: true

# Sets up environment for running specs and via irb e.g. `$ irb -r ./dev/setup`
require 'delegate'
require "pathname"

require 'rspec/core'
require 'colorize'
require 'stackprof'

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/enumerable'
require 'mime-types'
require 'faker'
require 'oj'
require 'rudash'
require 'dottie'
require 'addressable'
require 'rack/utils'
require 'measured'

%w[../../lib/rodash ../../spec/spec_helper].each do |rel_path|
  require File.expand_path(rel_path, Pathname.new(__FILE__).realpath)
end
