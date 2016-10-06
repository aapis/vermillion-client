module Vermillion
  class Endpoint
    def initialize(initial_path)
      @path = { default: initial_path }
      @server = nil
      @protocol = "http://"
    end

    def protocol=(use_https)
      @protocol = 'https://' if use_https
    end

    def server=(uri)
      @server = uri
    end

    def add(key, value)
      @path[key.to_sym] = value
    end

    def get(key)
      @path[key.to_sym]
    end

    def delete(key)
      @path.delete(key)
    end

    def exists?(key)
      @path.key? key
    end

    def to_s
      output = @protocol + @server
      @path.each_pair do |_k, value|
        output += value
      end
      output
    end
  end
end