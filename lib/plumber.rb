require_relative 'plumber/version'

require_relative 'plumber/pipe'
require_relative 'plumber/switch'
require_relative 'plumber/plug'

class X
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
class Y
  include Plumber::Switch
  private

  def select_pipe(value)
    value % 3
  end
end

class CsvSource
  include Plumber::Pipe

  def start
    puts "started"
    require 'csv'
    CSV.foreach(File.join(__dir__, '..', 'test', 'fixtures', 'test.csv')) do |row|
      flush_success(row)
    end
    puts "ended"
  end
end

class ToI
  include Plumber::Pipe

  def call(row)
    flush_success(row.first.to_i)
  end
end




x1 = X.new('pipe 1')
x2 = X.new('pipe 2')
x3 = X.new('pipe 3')
y = Y.new

source = CsvSource.new
to_i = ToI.new

y.connect(x1)
y.connect(x2)
y.connect(x3)

source.connect(to_i)
to_i.connect(y)
source.start
