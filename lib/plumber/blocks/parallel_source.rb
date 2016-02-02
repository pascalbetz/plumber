module Plumber
  module Blocks
    class ParallelSource
      include Plumber::Pipe
      include Celluloid

      def initialize(*sources)
        super()
        @sources = sources
      end

      def start
        forwarder = Forwarder.new(output_pipes[0])
        sources.each do |source|
          source.connect(forwarder)
          source.async.start
        end
      end

      private

      attr_reader :sources

      class Forwarder # avoid adding call to Parallel
        def initialize(target)
          @target = target
        end

        def call(value)
          @target.call(value)
        end
      end
    end
  end
end
