module Rordash
  class Chain
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def to_h
      @value = HashUtil.from_string(@value)

      self
    end

    def to_str
      @value = HashUtil.to_str(@value)

      self
    end

    def deep_compact
      @value = HashUtil.deep_compact(@value)

      self
    end

    def pick(paths)
      @value = HashUtil.pick(@value, paths)
      self
    end

    def merge(other)
      @value = @value.merge(other)
      self
    end

    def set(path, value)
      HashUtil.set(@value, path, value)
      self
    end
  end
end
