# Largely inspired by http://brizzled.clapper.org/blog/2010/12/20/some-jekyll-hacks/
require "forwardable"

module Jekyll
  module RpLogs
    # Holds arc information
    class Arc
      extend Forwardable
      include Comparable

      def_delegator :@name, :hash

      attr_accessor :name, :rps

      def initialize(name)
        # inspect types
        name.strip!
        @name = name

        @rps = []
        # potential future idea: directories for each arc
      end

      def <<(rp_page)
        @rps << rp_page
      end

      def start_date
        @rps.map { |rp_page| rp_page[:time_line] || rp_page[:start_date] }.min
      end

      def end_date
        @rps.map { |rp_page| rp_page[:last_post_time] }.max
      end

      def arc?
        true
      end

      def to_s
        name
      end

      def eql?(other)
        self.class == other.class &&
          name == other.name &&
          rps == other.rps
      end

      # actually by... start.. date?
      def <=>(other)
        name <=> other.name if self.class == other.class
      end

      def inspect
        self.class.name + "[" + @name + "]"
      end

      def to_liquid
        # Liquid wants a hash, not an object.

        { "name" => @name, "rps" => @rps }
      end
    end
  end
end
