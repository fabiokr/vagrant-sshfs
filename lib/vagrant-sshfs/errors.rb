module Vagrant
  module SshFS
    class Error < Errors::VagrantError
      error_namespace("vagrant.config.sshfs.error")
    end
  end
end
