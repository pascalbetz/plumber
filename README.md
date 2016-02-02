# Plumber

Plumber is an experiment on how an ETL framework could look like.

## Installation

As the gem is not yet published, you'll need to clone the repo and reference it.


## Usage

```ruby
# Build a source, make sure it
# * has a start method
# * flushes the values to a pipe (flush_success(value), flush_failure(value), flush(value, index))

class CsvSource
  include Plumber::Pipe

  def start
    CSV.foreach('test.csv') do |row|
      flush_success(row)
    end
  end
end

# Build processors/transformers. Make sure it
# * calls super, when overriding the initializer
# * forwards the values to a pipe (unless it should act as a sink)

class ConvertToInteger
  include Plumber::Pipe

  def call(row)
    flush_success(row.first.to_i)
  end
end

class Puts
  include Plumber::Pipe

  def initialize(prefix)
    super()
    @prefix = prefix
  end

  def call(value)
    puts "#{@prefix}: #{value}"
    flush_success(value)
  end
end


# Wire everything together

source = CsvSource.new
convert = ConvertToInteger.new
output = Puts.new('Something')

source.connect(convert).connect(output)

# Start processing
source.start

```

Use Celluloid Actors to decouple or parallelize. See examples.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pascalbetz/plumber.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
