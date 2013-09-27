module Vagrant
  module SshFS
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :paths

      def initialize
        @paths = {}
      end

      def merge(other)
        super.tap do |result|
          result.paths = @paths.merge(other.paths)
        end
      end
    end
  end
end
