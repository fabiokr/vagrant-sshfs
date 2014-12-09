require 'vagrant-sshfs/builders/base'
require 'vagrant-sshfs/builders/host'
require 'vagrant-sshfs/builders/guest'

module Vagrant
  module SshFS
    module Actions
      class Base
        def initialize(app, env)
          @machine = env[:machine]
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

      class Up < Base
        def call(env)
          get_builder(env).mount! if @machine.config.sshfs.enabled
        end
      end

      class Destroy < Base
        def call(env)
          get_builder(env).unmount! if @machine.config.sshfs.enabled
        end
      end

      class Reload < Up; end
      class Provision < Up; end
      class Suspend < Destroy; end
      class Resume < Up; end
      class Halt < Destroy; end
    end
  end
end
