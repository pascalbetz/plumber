module Plumber
  module Switch
    include Plumber::Pipe

    module InstanceMethods

      def call(value)
        flush(value, select_pipe(value))
      end

      private

      def select_pipe
        DEFAULT_PIPE_NUMBER_SUCCESS
      end
    end

    def self.included(base)
      base.send(:include, InstanceMethods)
    end
  end
end
