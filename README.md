# Rordash

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/rordash`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rordash'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rordash

## HashUtil

### .from_string

> parses a JSON string and convert it to a Ruby hash.

Example:

```ruby
json_str = '{"name": "John", "age": 30, "city": "New York"}'
hash = Rordash::HashUtil.from_string(json_str)
puts hash
# => { :name=>"John", :age=>30, :city=>"New York" }
```

### .to_str

> converts Hash/Array into a string

Example:

```ruby
# Example 1: Serialize a hash to a JSON string
hash = { name: "John", age: 30, city: "New York" }
json_str = Rordash::HashUtil.to_str(hash)
puts json_str
# Output: {"name":"John","age":30,"city":"New York"}

# Example 2: Serialize an array to a JSON string
arr = [1, "two", { three: 3 }]
json_str = Rordash::HashUtil.to_str(arr)
puts json_str
# Output: [1,"two",{"three":3}]

# Example 3: Serialize a non-hash, non-array object to a string
obj = 123
str = Rordash::HashUtil.to_str(obj)
puts str
# Output: "123"
```

### .pretty

> Pretty-prints hash or array contents

Example:

```ruby
# Example 1: Pretty-print a hash as a JSON string
hash = { name: "John", age: 30, city: "New York" }
json_str = Rordash::HashUtil.pretty(hash)
puts json_str
# Output:
# {
#   "name": "John",
#   "age": 30,
#   "city": "New York"
# }

# Example 2: Pretty-print an array as a JSON string
arr = [1, "two", { three: 3 }]
json_str = Rordash::HashUtil.pretty(arr)
puts json_str
# Output:
# [
#   1,
#   "two",
#   {
#     "three": 3
#   }
# ]

# Example 3: Return a non-hash, non-array object as is
obj = 123
result = Rordash::HashUtil.pretty(obj)
puts result
# Output: 123
```

### .get
> retrieves the value at a given JSON dot notation path

Example:

```ruby
# Example 1: Get a value from a hash
hash = { name: { first: "John", last: "Doe" }, age: 30 }
value = Rordash::HashUtil.get(hash, "name.first")
puts value
# Output: "John"

# Example 2: Get a value from an array
arr = [{ name: "John" }, { name: "Jane" }]
value = Rordash::HashUtil.get(arr, "1.name")
puts value
# Output: "Jane"

# Example 3: Path not found, return default value
hash = { name: { first: "John", last: "Doe" }, age: 30 }
value = Rordash::HashUtil.get(hash, "address.city", default: "Unknown")
puts value
# Output: "Unknown"

```

### .get_first_present
> returns the first value matching one of `dotted_paths`

Example:

```ruby
# Example 1: Get first present value from hash
hash = { name: { first: "", last: "Doe" }, age: nil, city: "New York" }
value = Rordash::HashUtil.get_first_present(hash, ["name.first", "name.last", "age", "city"])
puts value
# Output: "Doe"

# Example 2: Get first present value from array of hashes
arr = [
  { name: "John", age: 30 },
  { name: "Jane", age: nil },
  { name: "Jim", age: 40 }
]
value = Rordash::HashUtil.get_first_present(arr, ["1.age", "2.name", "0.age"])
puts value
# Output: 40

# Example 3: No present values, return nil
hash = { name: "", age: nil, city: "" }
value = Rordash::HashUtil.get_first_present(hash, ["name.first", "age", "city"])
puts value
# Output: nil
```

### .set
> .set method to set the value of the key at the specified path in the hash to the provided value.

Example:

```ruby
# Example 1: Set a value in a hash
hash = { name: { first: "John", last: "Doe" }, age: 30 }
Rordash::HashUtil.set(hash, "name.first", "Jane")
puts hash
# Output: { name: { first: "Jane", last: "Doe" }, age: 30 }

# Example 2: Set a value in a new key
hash = { name: { first: "John", last: "Doe" }, age: 30 }
Rordash::HashUtil.set(hash, "name.middle", "Allen")
puts hash
# Output: { name: { first: "John", last: "Doe", middle: "Allen" }, age: 30 }

```

### .group_by
> groups the elements of the enumerable by the key returned by the grouping function.

Example:

```ruby
# Example 1: Group an array of hashes by a key
people = [
  { name: "John", age: 30 },
  { name: "Jane", age: 25 },
  { name: "Jim", age: 30 },
  { name: "Janet", age: 25 }
]
grouped = Rordash::HashUtil.group_by(people, :age)
puts grouped
# Output: { 30 => [{ name: "John", age: 30 }, { name: "Jim", age: 30 }],
#           25 => [{ name: "Jane", age: 25 }, { name: "Janet", age: 25 }] }

# Example 2: Group a hash of arrays by a proc
people = {
  adults: [{ name: "John", age: 30 }, { name: "Jim", age: 30 }],
  children: [{ name: "Jane", age: 5 }, { name: "Janet", age: 8 }]
}
grouped = Rordash::HashUtil.group_by(people) { |_, v| v.length > 1 ? :multiple : :single }
puts grouped
# Output: { multiple => [:adults => [{ name: "John", age: 30 }, { name: "Jim", age: 30 }]],
#           single => [:children => [{ name: "Jane", age: 5 }, { name: "Janet", age: 8 }]] }

```

### .dot
> Converts a nested hash into a flattened hash

Example:

```ruby
# Example 1: Flattening a nested hash
nested_hash = {
  user: {
    name: {
      first: "John",
      last: "Doe"
    },
    age: 30,
    interests: ["coding", "reading"]
  },
  company: {
    name: "Acme Inc.",
    address: {
      street: "123 Main St",
      city: "Anytown",
      state: "CA"
    }
  }
}
flat_hash = Rordash::HashUtil.dot(nested_hash)
puts flat_hash
# Output: {
#   "user.name.first" => "John",
#   "user.name.last" => "Doe",
#   "user.age" => 30,
#   "user.interests" => ["coding", "reading"],
#   "company.name" => "Acme Inc.",
#   "company.address.street" => "123 Main St",
#   "company.address.city" => "Anytown",
#   "company.address.state" => "CA"
# }

# Example 2: Flattening a nested hash and excluding arrays
nested_hash = {
  user: {
    name: {
      first: "John",
      last: "Doe"
    },
    age: 30,
    interests: ["coding", "reading"]
  },
  company: {
    name: "Acme Inc.",
    address: {
      street: "123 Main St",
      city: "Anytown",
      state: "CA"
    }
  }
}
flat_hash = Rordash::HashUtil.dot(nested_hash, keep_arrays: false)
puts flat_hash
# Output: {
#   "user.name.first" => "John",
#   "user.name.last" => "Doe",
#   "user.age" => 30,
#   "company.name" => "Acme Inc.",
#   "company.address.street" => "123 Main St",
#   "company.address.city" => "Anytown",
#   "company.address.state" => "CA"
# }

# Example 3: Flattening a nested hash and transforming values with a block
nested_hash = {
  user: {
    name: {
      first: "John",
      last: "Doe"
    },
    age: 30,
    interests: ["coding", "reading"]
  }
}
flat_hash = Rordash::HashUtil.dot(nested_hash) do |key, value|
  key.start_with?("user") ? value.upcase : value
end
puts flat_hash
# Output: {
#   "user.name.first" => "JOHN",
# ...
# }

```

### .deep_key?
> checks if a given key exists in a hash or nested hash.

Example:

```ruby
hash = { 'a' => { 'b' => { 'c' => 1 } } }
Rordash::HashUtil.deep_key?(hash, 'a.b.c')  # returns true
Rordash::HashUtil.deep_key?(hash, 'a.b.d')  # returns false
Rordash::HashUtil.deep_key?(hash, 'a')      # returns true
Rordash::HashUtil.deep_key?(hash, 'x.y.z')  # returns false
```

### .dotted_keys method returns an array of all the dotted keys in a hash or nested hash.

Example:

```ruby
hash = { 'a' => { 'b' => { 'c' => 1 } } }
Rordash::HashUtil.dotted_keys(hash)        # returns ['a.b.c']
Rordash::HashUtil.dotted_keys(hash, false) # returns ['a', 'a.b', 'a.b.c']
```

### .pick

> Extracts a subset of a hash based on the given paths

Example:

```ruby
hash = { a: 1, b: { c: 2, d: { e: 3 } } }
Rordash::HashUtil.pick(hash, 'a')          # returns { a: 1 }
Rordash::HashUtil.pick(hash, 'b.c')        # returns { b: { c: 2 } }
Rordash::HashUtil.pick(hash, 'b.d.e')      # returns { b: { d: { e: 3 } } }
Rordash::HashUtil.pick(hash, ['a', 'b.d']) # returns { a: 1, b: { d: { e: 3 } } }
```

### .undot
> Converts a dotted hash into a regular hash

```ruby
dotted_hash = {
  "person.name.first": "John",
  "person.name.last": "Doe",
  "person.age": 30
}

regular_hash = Rordash::HashUtil.undot(dotted_hash)

# Output:
# {
#   "person" => {
#     "name" => {
#       "first" => "John",
#       "last" => "Doe"
#     },
#     "age" => 30
#   }
# }

dotted_hash = {
  "person.name.first": "John",
  "person.name.last": "Doe",
  "person.age": 30
}

# Usage with a block
regular_hash = Rordash::HashUtil.undot(dotted_hash) do |key, value|
  if key == "person.name.first"
    value.upcase
  else
    value
  end
end

# Output:
# {
#   "person" => {
#     "name" => {
#       "first" => "JOHN",
#       "last" => "Doe"
#     },
#     "age" => 30
#   }
# }

```

### .deep_compact
> Recursively compacts all values from a nested hash

```ruby
hash = { foo: { bar: [1, 2, nil] }, baz: { qux: nil } }
result = Rordash::HashUtil.deep_compact(hash)  # => { foo: { bar: [1, 2] } }

# using each_value_proc to remove nils and blank strings
result = Rordash::HashUtil.deep_compact(hash) do |k, v|
  if v.is_a?(String)
    v.strip!
    v unless v.empty?
  else
    v.compact
  end
end
```

### .reject_blank_values
> Rejects key value pairs that are considered blank

Example:
```ruby
obj = { foo: '', bar: '  ', baz: nil, qux: [1, 2, '', nil] }
result = Rordash::HashUtil.reject_blank_values(obj)
puts result.inspect # output: { bar: '', qux: [1, 2] }
```

### .deep_reject_blank_values
> Rejects key value pairs that are considered blank from nested hashes

Example:

```ruby
# Define a hash with nested arrays and values
attrs = {
  name: 'John',
  age: nil,
  address: {
    street: '123 Main St',
    city: 'Anytown',
    state: '',
    zip: '  ',
  },
  phones: [
    {
      type: 'home',
      number: '123-456-7890',
      ext: '',
    },
    {
      type: 'work',
      number: '',
      ext: nil,
    },
    {
      type: '',
      number: '',
      ext: '',
    },
  ]
}

# Remove all nil, empty, or blank values recursively
clean_attrs = Rordash::HashUtil.deep_reject_blank_values(attrs)

# Print the cleaned hash
puts clean_attrs.inspect

```

### .deep_symbolize_keys
> Recursively symbolizes all the keys in a nested hash or array.

Example:

```ruby
hash = { 'foo' => { 'bar' => 'baz' }, 'arr' => [{ 'a' => 1 }, { 'b' => 2 }] }
Utils::HashUtil.deep_symbolize_keys(hash)
#=> { :foo => { :bar => "baz" }, :arr => [{ :a => 1 }, { :b => 2 }] }

```

## NumericUtil

### .numeric?
> returns a boolean indicating whether the value is numeric or not

Example:

```ruby
numeric?("123") #=> true
numeric?("123.45") #=> true
numeric?("abc") #=> false
numeric?("") #=> false
numeric?(nil) #=> false
```

### .convert_unit
> Convert a value from one unit to another. Specifically, it's using the `Measured::Length` class to perform conversions

Example:

```ruby
# convert 10 meters to feet
converted_value = convert_unit(10, from_unit: :meters, to_unit: :feet)
puts converted_value # output: 32.80839895013123
```

### .convert_unit_sq 
> Converts an area from one unit to another.

Example:

```ruby
# Convert an area of 10 square feet to square meters
value = 10
from_unit = 'ft^2'
to_unit = 'm^2'
converted_value = convert_unit_sq(value, from_unit: from_unit, to_unit: to_unit)

puts "#{value} #{from_unit} is equal to #{converted_value} #{to_unit}"
# Output: "10 ft^2 is equal to 0.9290304 m^2"
```
## FileUtil

### .filename_with_ext_from

> generates appropriate filename and extension

Example:

```ruby
filename = "myfile"
content_type = "image/png"
new_filename = Rordash::FileUtil.filename_with_ext_from(filename: filename, content_type: content_type)
puts new_filename # "myfile.png"
```

### .content_type_to_extension

> maps a content type string to its corresponding file extension.

Example:

```ruby
content_type = "application/pdf"
extension = Rordash::FileUtil.content_type_to_extension(content_type)
puts extension # "pdf"
```

### .fixture_file_path 
> returns the absolute file path for a file under spec/fixtures/files directory.

Example:

```ruby
file_path = Rordash::FileUtil.fixture_file_path('example.txt')
#=> #<Pathname:/Users/<username>/repo/spec/fixtures/files/sample.csv>
```

### .read_fixture_file 
> Reads the contents of a file located in the project's fixture directory. 

Example:
```ruby
Rordash::FileUtil.read_fixture_file('sample.csv')
#=> "name,date,favorite_color\nJohn Smith,Oct 2 1901,blue\nGemma Jones,Sept 1 2018,silver"
```

### .open_fixture_file 

> returns a File object for a given fixture file.

Example:

```ruby
file = Rordash::FileUtil.open_fixture_file('sample.csv')
#=> <File:/Users/<username>/repo/spec/fixtures/files/sample.csv>

if file.nil?
  puts "Fixture file does not exist"
else
  puts "Fixture file contents:"
  puts file.read
  file.close
end
```

### .read_fixture_file_as_hash 

> reads the contents of a fixture file, specified by its relative path, and returns it as a hash.

Example:

```ruby
# Given a fixture file `sample.json` with the following content:
# [
#   {
#     "color": "red",
#     "value": "#f00"
#   }
# ]

# We can read it as a hash using the `read_fixture_file_as_hash` method:
hash = Rordash::FileUtil.read_fixture_file_as_hash('sample.json')
puts hash.inspect
# Output: [{:color=>"red", :value=>"#f00"}]
```

### .create_file_blob
> Creates an ActiveStorage::Blob record for a file specified by its filename. Useful for creating ActiveStorage::Blob records in a test environment.

```ruby
blob = Rordash::FileUtil.create_file_blob('sample.json')
puts blob
#=> <ActiveStorage::Blob>
```

### .file_url_for
> Generates a URL for a file. It takes a filename as input and returns a string URL.

Example:

```ruby
url = Rordash::FileUtil.file_url_for(filename)
#=> "http://jaskolski.biz/example.txt"
```

### .content_type_from_filename 
> determines the content type of a file based on its extension.

Example:

```ruby
content_type = DebugUtil.content_type_from_filename('my_file.jpg')
puts content_type # => "image/jpeg"
```

## DebugUtil

### .calculate_duration

> `.calculate_duration` calculates the duration of a block of code and logs it to the console.

```ruby
Rordash::DebugUtil.calculate_duration(tag: 'my_code_block') do
  # your code here
end
```

This will log the duration with the specified tag: `tag: my_code_block - total duration - 0 hours 0 minutes and 0.0 seconds`.

### .wrap_stack_prof

> `.wrap_stack_prof` runs a code block and profiles its execution with `StackProf`. Useful for identifying performance bottlenecks in your code.

To use `.wrap_stack_prof`, simply pass a block of code as an argument to the method. For example:

```ruby
Rordash::DebugUtil.wrap_stack_prof(tag: 'my_profile_run', out: 'path/to/output.dump') do
  # your code here
end
```

This will log the duration and output file with the specified tag: `tag: my_profile_run - total duration - 0 hours 0 minutes and 0.0 seconds` and `StackProf` `output file: path/to/output.dump`.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rordash. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rordash/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rordash project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rordash/blob/master/CODE_OF_CONDUCT.md).
