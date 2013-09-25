module Vagrant
  module SshFS
    module Actions
      class Builder
        def initialize
          @source, @target = "/home/vagrant/src", "~/dev/teste"
        end

        def mount!
          `echo vagrant | sshfs vagrant@192.168.1.99:#{@source} #{@target} -o workaround=rename -o password_stdin`
        end

        def unmount!
          `fusermount -u #{@target}`
        end
      end

      class Up
        def initialize(app, env)
          @app     = app
          @machine = env[:machine]
        end

        def call(env)
          env[:ui].info "Mounting SSHFS"
          Builder.new.mount!
        end
      end

      class Destroy
        def initialize(app, env)
          @app     = app
          @machine = env[:machine]
        end

        def call(env)
          env[:ui].info "Unmounting SSHFS"
          Builder.new.unmount!
        end
      end
    end
  end
end
