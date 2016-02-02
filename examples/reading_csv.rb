require_relative '../lib/plumber'
require 'csv'

class PutsPipe
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

class Distribute
  include Plumber::Pipe

  def call(value)
    flush(value, value % 3)
  end
end

class CsvSource
  include Plumber::Pipe
  include Celluloid

  def start
    CSV.foreach(File.join(__dir__, '..', 'test', 'fixtures', 'test.csv')) do |row|
      flush_success(row)
    end
  end
end

class ToI
  include Plumber::Pipe

  def call(row)
    flush_success(row.first.to_i)
  end
end




puts_1 = PutsPipe.new('Pipe 1')
puts_2 = PutsPipe.new('Pipe 2')
puts_3 = PutsPipe.new('Pipe 3')
distribute = Distribute.new

distribute.connect(puts_1)
distribute.connect(puts_2)
distribute.connect(puts_3)

convert_to_i = ToI.new
convert_to_i.connect(distribute)

source = Plumber::Blocks::ParallelSource.new(CsvSource.new, CsvSource.new, CsvSource.new)
source.connect(convert_to_i)
source.start
