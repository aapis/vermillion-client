module Vermillion
  class Request
    attr_reader :controller, :command, :custom, :flags, :raw_flags, :param

    def initialize
      @controller = nil
      @flags = ARGV.select { |f| f.start_with?('-') }.map { |f| f.split("=").map(&:to_sym) } || []
      @raw_flags = ARGV.select { |f| f.start_with?('-') } || []

      unless ARGV.empty?
        begin
          @controller = ARGV[0].to_sym unless ARGV[0].start_with?('-')
          @command = ARGV[1].to_sym
        rescue NoMethodError => e
          @controller = nil
          @command = nil

          Notify.warning(e.message, show_time: false)
        end

        if ARGV.size > 2
          @custom = ARGV[2..ARGV.size].select { |p| !p.start_with?('-') }.map(&:to_sym) || []
          @param = ARGV[2]
        end
      end
    end
  end
end
