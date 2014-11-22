require 'fileutils'

module Vagrant
  module SshFS
    module Builders
      class Host < Base
        private

        def unmount(target)
          if `which fusermount`.empty?
            `umount #{target}`
          else
            `fusermount -u -q #{target}`
          end
        end

        def mount(src, target)
          `#{sshfs_bin} -p #{port} #{username}@#{host}:#{check_src!(src)} #{check_target!(target)} -o IdentityFile=#{private_key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null `
        end

        def ssh_info
          machine.ssh_info
        end

        def username
          machine.config.sshfs.username ||= ssh_info[:username]
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

        def sshfs_bin
          bin = `which sshfs`.chomp

          if bin.empty?
            error("bin_not_found")
          else
            bin
          end
        end

        def check_src!(src)
          unless machine.communicate.test("test -d #{src}")
            if machine.config.sshfs.prompt_сreate_folders == false || ask("create_src", src: src) == "y"
              if machine.config.sshfs.sudo
                machine.communicate.execute("sudo su -c 'mkdir -p #{src}'")
              else
                machine.communicate.execute("mkdir -p #{src}")
              end
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
            if machine.config.sshfs.prompt_сreate_folders == false || ask("create_target", target: folder) == "y"
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
      end
    end
  end
end
