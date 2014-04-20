module Vagrant
  module SshFS
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :paths
      attr_accessor :username
      attr_accessor :enabled
      attr_accessor :mount_on_guest
      attr_accessor :host_addr

      def initialize
        @paths = {}
        @username = nil
        @enabled = true
      end

      def merge(other)
        super.tap do |result|
          result.paths = @paths.merge(other.paths)
        end
      end
    end
  end
end
