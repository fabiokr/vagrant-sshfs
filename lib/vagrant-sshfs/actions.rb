require 'vagrant-sshfs/builders/base'
require 'vagrant-sshfs/builders/host'
require 'vagrant-sshfs/builders/guest'

module Vagrant
  module SshFS
    module Actions
      class Up
        def initialize(app, env)
          @machine = env[:machine]
        end

        def call(env)
          get_builder(env).mount! if @machine.config.sshfs.enabled
        end

        private

        def get_builder(env)
          if @machine.config.sshfs.mount_on_guest
            Builders::Guest.new(env[:machine], env[:ui])
          else
            Builders::Host.new(env[:machine], env[:ui])
          end
        end
      end

      class Reload < Up; end
    end
  end
end
