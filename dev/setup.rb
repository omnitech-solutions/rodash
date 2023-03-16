# frozen_string_literal: true

# Sets up environment for running specs and via irb e.g. `$ irb -r ./dev/setup`
require "pathname"
require 'rspec/core'

%w[../../lib/rordash ../../spec/spec_helper].each do |rel_path|
  require File.expand_path(rel_path, Pathname.new(__FILE__).realpath)
end
