module Plumber
  module Blocks
    class Decoupler
      include Plumber::Pipe
      include Celluloid

      def call(value)
        async.flush(value)
      end
    end
  end
end
