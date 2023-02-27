# frozen_string_literal: true

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
