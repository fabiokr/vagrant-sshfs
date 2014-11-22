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

      action_hook(:sshfs, :machine_action_reload) do |hook|
        hook.append(Vagrant::SshFS::Actions::Reload)
      end

      action_hook(:sshfs, :machine_action_provision) do |hook|
        hook.append(Vagrant::SshFS::Actions::Provision)
      end

      action_hook(:sshfs, :machine_action_suspend) do |hook|
        hook.append(Vagrant::SshFS::Actions::Suspend)
      end

      action_hook(:sshfs, :machine_action_resume) do |hook|
        hook.append(Vagrant::SshFS::Actions::Resume)
      end

      action_hook(:sshfs, :machine_action_halt) do |hook|
        hook.append(Vagrant::SshFS::Actions::Halt)
      end

      action_hook(:sshfs, :machine_action_destroy) do |hook|
        hook.append(Vagrant::SshFS::Actions::Destroy)
      end

      command "sshfs" do
        Vagrant::SshFS::Command
      end
    end
  end
end
