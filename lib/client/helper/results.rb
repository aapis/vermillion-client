module Vermillion
  module Helper
    class Results
      # Internal array to hold all the result values
      attr_reader :bucket

      # Create the Results object
      def initialize
        @bucket = []
        @bucket
      end

      # Add a result for processing
      # Params:
      # +result+:: The value you want to store
      def add(result)
        @bucket.push(result)
        result
      end

      # Check if all values match a specified value
      # Params:
      # +pass_value+:: What all values in the array should evaluate to
      def should_eval_to(pass_value)
        @bucket.all? == pass_value
      end
    end
  end
end
