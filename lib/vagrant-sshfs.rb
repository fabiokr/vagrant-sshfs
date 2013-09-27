require "vagrant-sshfs/actions"

module Vagrant
  module SshFS
    class Plugin < Vagrant.plugin("2")
      name "vagrant-sshfs"
      description "A Vagrant plugin that mounts sshfs in the host machine."

      config "sshfs" do
        require "vagrant-sshfs/config"
        Config
      end

      action_hook(:sshfs, :machine_action_up) do |hook|
        hook.append(Vagrant::SshFS::Actions::Up)
      end

      action_hook(:sshfs, :machine_action_destroy) do |hook|
        hook.append(Vagrant::SshFS::Actions::Destroy)
      end
    end
  end
end
