# frozen_string_literal: true

require 'delegate'
require 'colorize'
require 'stackprof'

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/enumerable'
require 'active_support/hash_with_indifferent_access'
require 'mime-types'
require 'faker'
require 'oj'
require 'rudash'
require 'dottie'
require 'addressable'
require 'rack/utils'
require 'measured'
require 'rordash'

%w[
version
debug_util
regex_util
hash_util
path_util
file_util
url_util
object_util
numeric_util
chain
].each do |filename|
  require File.expand_path("../rordash/#{filename}", Pathname.new(__FILE__).realpath)
end

module Rordash
  class << self
    def chain(value)
      Chain.new(value.dup)
    end
  end
end
