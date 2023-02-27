# frozen_string_literal: true

module Rordash
  # rubocop:disable Metrics/ModuleLength
  module HashUtil
    ROOT_PATHS = %w[. *].freeze

    class << self
      def from_string(json_str)
        return json_str unless json_str.is_a?(String)

        Oj.load(json_str, symbol_keys: true)
      end

      def to_str(obj)
        return Oj.dump(obj.deep_stringify_keys) if hash_or_array?(obj)

        obj.to_s
      end

      def pretty(obj)
        return obj unless hash_or_array?(obj)

        JSON.pretty_generate(obj)
      end

      def get(obj, path, default: nil)
        return obj if ROOT_PATHS.include?(path)

        value = R_.get(obj, path.to_s)
        return default if value.nil?

        value
      end

      def get_first_present(obj, dotted_paths)
        dotted_paths.each do |path|
          value = R_.get(obj, path)
          return value if value.present?
        end

        nil
      end

      def set(hash, path, value)
        R_.set(hash, path.to_s, value)
      end

      def group_by(obj, key_or_proc)
        proc = if key_or_proc.is_a?(Proc)
                 key_or_proc
               else
                 ->(hash) { R_.get(hash, key_or_proc.to_s) }
               end

        R_.group_by(obj, proc)
      end

      def dot(hash, keep_arrays: true, &block)
        return Dottie.flatten(hash) unless keep_arrays

        results = {}
        Dottie.flatten(hash, intermediate: true).each do |k, v|
          next if RegexUtil.match?(:dotted_index, k)
          next if v.is_a?(::Hash)

          value = block ? yield(k, v) : v
          results.merge!(k => value)
        end

        results
      end

      def deep_key?(obj, key)
        return false unless obj.is_a?(::Hash)
        return obj.key?(key) unless key.is_a?(String) && key.include?('.')

        dotted_keys(obj).include?(key)
      end

      def dotted_keys(obj, keep_arrays: true)
        dot(obj, keep_arrays: keep_arrays).keys
      end

      # rubocop:disable Metrics/MethodLength,Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity,Metrics/AbcSize
      def pick(hash, paths, keep_arrays: true)
        all_paths = paths.is_a?(Array) ? paths.map(&:to_s) : [paths.to_s]
        has_deep_paths = all_paths.any? { |path| path.include?('.') }

        results = {}
        dotted_hash = has_deep_paths ? Dottie.flatten(hash, intermediate: true) : hash
        filtered_keys = dotted_hash.keys.select { |path| all_paths.include?(path.to_s) }
        filtered_dotted_hash = dotted_hash.slice(*filtered_keys)

        return filtered_dotted_hash unless has_deep_paths

        if keep_arrays
          filtered_dotted_hash.each_pair { |k, v| Utils::HashUtil.set(results, k, v) }
          return results
        else
          filtered_dotted_hash.each_pair do |dotted_key, val|
            stringify_dotted_key = dotted_key.to_s
            next if all_paths.exclude?(stringify_dotted_key)

            should_reconstruct_array = RegexUtil.match?(:dotted_index, stringify_dotted_key)
            key = should_reconstruct_array ? dotted_key.split('[').first : dotted_key
            value = should_reconstruct_array ? (results[key] || []).push(val) : val

            results.merge!(key => value)
          end
        end

        undot(results)
      end
      # rubocop:enable Metrics/MethodLength,Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity,Metrics/AbcSize

      def undot(hash, &block)
        results = {}
        Dottie.flatten(hash, { intermediate: false }).each do |k, v|
          value = block ? yield(k, v) : v
          set(results, k, value)
        end
        results
      end

      def deep_compact(attrs, each_value_proc: nil)
        result = {}

        dot(attrs, keep_arrays: true) do |k, v|
          value = each_value_proc.respond_to?(:call) ? each_value_proc&.call(k, v) : v.compact
          next if value.nil?

          set(result, k, value)
        end

        result
      end

      def reject_blank_values(obj)
        return obj unless hash_or_array?(obj)

        obj.compact.reduce({}) do |memo, (k, v)|
          v = v.is_a?(String) ? v.strip : v
          next memo if !hash_or_array?(v) && v.blank?

          memo.merge(k => v)
        end
      end

      def deep_reject_blank_values(attrs)
        deep_compact(attrs, each_value_proc: lambda do |_k, v|
          v = v.is_a?(String) ? v.strip : v
          v = v.compact if hash_or_array?(v)
          if v.is_a?(Array)
            v = v.reject do |val|
              val = val.is_a?(String) ? val.strip : val
              val.blank?
            end
          end
          v.blank? ? nil : v
        end)
      end

      def deep_symbolize_keys(obj)
        return obj unless hash_or_array?(obj)
        return obj.deep_symbolize_keys if obj.is_a?(::Hash)

        obj.map { |item| item.is_a?(::Hash) ? item.deep_symbolize_keys : item }
      end

      def digest(obj)
        Digest::SHA1.base64digest Marshal.dump(obj)
      end

      def hash_or_array?(obj)
        obj.is_a?(::Hash) || obj.is_a?(Array)
      end
    end
  end
  # rubocop:enable Metrics/ModuleLength
end
