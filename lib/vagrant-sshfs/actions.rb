require 'fileutils'

module Vagrant
  module SshFS
    module Actions
      class Builder
        def initialize(env)
          @env = env
        end

        def mount!
          paths.each do |src, target|
            info("mounting", src: src, target: target)
            `sshfs -p #{port} #{username}@#{host}:#{check_src!(src)} #{check_target!(target)} -o IdentityFile=#{private_key}`
          end
        end

        private

        def paths
          machine.config.sshfs.paths
        end

        def ssh_info
          machine.ssh_info
        end

        def username
          ssh_info[:username]
        end

        def host
          ssh_info[:host]
        end

        def port
          ssh_info[:port]
        end

        def private_key
          Array(ssh_info[:private_key_path]).first
        end

        def check_src!(src)
          unless machine.communicate.test("test -d #{src}")
            if ask("create_src", src: src) == "y"
              machine.communicate.execute("mkdir -p #{src}")
              info("created_src", src: src)
            else
              error("not_created_src", src: src)
            end
          end

          src
        end

        def check_target!(target)
          folder = target_folder(target)

          # entries return . and .. when empty
          if File.exist?(folder) && Dir.entries(folder).size > 2
            error("non_empty_target", target: folder)
          elsif !File.exist?(folder)
            if ask("create_target", target: folder) == "y"
              FileUtils.mkdir_p(folder)
              info("created_target", target: folder)
            else
              error("not_created_target", target: folder)
            end
          end

          folder
        end

        def target_folder(target)
          File.expand_path(target)
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

      class Up
        def initialize(app, env)
          @app     = app
          @machine = env[:machine]
        end

        def call(env)
          Builder.new(env).mount!
        end
      end
    end
  end
end
