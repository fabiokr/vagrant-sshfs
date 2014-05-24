module Vagrant
  module SshFS
    class Command < Vagrant.plugin(2, :command)
      def self.synopsis
        "mounts sshfs shared folders"
      end

      def execute
        with_target_vms do |machine|
          get_builder(machine).mount!
        end

        0
      end

      private

      def get_builder(machine)
        if machine.config.sshfs.mount_on_guest
          Builders::Guest.new(machine, @env.ui)
        else
          Builders::Host.new(machine, @env.ui)
        end
      end
    end
  end
end
