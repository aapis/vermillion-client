module Vermillion
  module Helper
    class Time
      # Human readable strings to represent the length between two time objects
      # Params:
      # +start+:: Start time object
      # +finish+:: End time object
      def self.human_readable(start, finish)
        seconds = finish.to_f - start.to_f

        if seconds < 60
          "No time at all!"
        else
          minutes = (seconds / 60).round(1)
          if minutes < 1
            "#{minutes} minute"
          else
            "#{minutes} minutes"
          end
        end
      end

      # Use the following format for a given timestamp: "d/m/y @ H:M:S AM/PM"
      # Params:
      # +time+:: Optional time value, uses the current time if not provided,
      #          to format
      def self.formatted(time = nil)
        time = ::Time.now if time.nil?
        time.strftime("%e/%-m/%Y @ %I:%M:%S%P")
      end
    end
  end
end
