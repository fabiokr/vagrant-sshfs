module Vagrant
  module SshFS
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :paths
      attr_accessor :username

      def initialize
        @paths = {}
        @username = nil
      end

      def merge(other)
        super.tap do |result|
          result.paths = @paths.merge(other.paths)
        end
      end
    end
  end
end
