module Plumber
  module Pipe

    module InstanceMethods
      DEFAULT_PIPE_NUMBER_SUCCESS = 0
      DEFAULT_PIPE_NUMBER_FAILURE = 1

      def initialize
        @output_pipes = []
      end

      def connect(pipe, output_number = output_pipes.size)
        output_pipes[output_number] = pipe
      end

      private
      attr_reader :output_pipes

      def flush_success(value)
        flush(value, DEFAULT_PIPE_NUMBER_SUCCESS)
      end

      def flush_failure(value)
        flush(value, DEFAULT_PIPE_NUMBER_FAILURE)
      end

      def flush(value, output_number = DEFAULT_PIPE_NUMBER_SUCCESS)
        pipe = output_pipes[output_number] || Plumber::Blocks::Plug.new # TODO: nice...but probably better to raise an info
        pipe.call(value)
      end
    end

    def self.included(base)
      base.send(:include, InstanceMethods)
    end
  end

end
