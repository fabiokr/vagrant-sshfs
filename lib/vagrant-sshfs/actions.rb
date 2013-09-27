require 'fileutils'

module Vagrant
  module SshFS
    class Error < Errors::VagrantError; end

    module Actions
      class Builder
        def initialize(env)
          @env = env
        end

        def mount!
          paths.each do |src, target|
            @env[:ui].info "Mounting SSHFS for #{src} to #{target}"

            check_target(target)

            `sshfs -p #{port} #{username}@#{host}:/home/#{username}/#{src} #{target} -o IdentityFile=#{private_key}`
          end
        end

        def unmount!
          # `fusermount -u #{@target}`
        end

        private

        def paths
          @env[:machine].config.sshfs.paths
        end

        def ssh_info
          @env[:machine].ssh_info
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
          ssh_info[:private_key_path]
        end

        def check_target(target)
          folder = target_folder(target)

          # entries return . and .. when empty
          if File.exist?(folder) && Dir.entries(folder).size > 2
            raise Error, "Non empty target folder #{target}"
          elsif !File.exist?(folder)
            if @env[:ui].ask("Target folder #{folder} does not exist, create?", :new_line => true) == "y"
              FileUtils.mkdir_p(folder)
              @env[:ui].info "Created target #{folder}"
            else
              raise Error, "Target folder #{folder} was not created"
            end
          end
        end

        def target_folder(target)
          File.expand_path(target)
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

      class Destroy
        def initialize(app, env)
          @app     = app
          @machine = env[:machine]
        end

        def call(env)
          env[:ui].info "Unmounting SSHFS"
          Builder.new(env).unmount!
        end
      end
    end
  end
end
