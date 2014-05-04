module Vagrant
  module SshFS
    module Actions
      module Builders
        class Base
          def initialize(env)
            @env = env
          end

          def mount!
            paths.each do |src, target|
              info("unmounting", src: target)
              unmount(target)
              info("mounting", src: src, target: target)
              mount(src, target)
            end
          end

          def mount
            raise NotImplementedError
          end

          def paths
            machine.config.sshfs.paths
          end

          def machine
            @env[:machine]
          end

          def info(key, *args)
            @env[:ui].info(i18n("info.#{key}", *args))
          end

          def ask(key, *args)
            @env[:ui].ask(i18n("ask.#{key}", *args), :new_line => true)
          end

          def error(key, *args)
            @env[:ui].error(i18n("error.#{key}", *args))
            raise Error, :base
          end

          def i18n(key, *args)
            I18n.t("vagrant.config.sshfs.#{key}", *args)
          end
        end
      end
    end
  end
end
