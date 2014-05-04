module Vagrant
  module SshFS
    module Actions
      module Builders
        class Guest < Base
          private

          def mount(src, target)
            source = File.expand_path(src)

            status = machine.communicate.execute(
              "echo \"#{password}\" | sshfs -o allow_other -o password_stdin #{username}@#{host}:#{source} #{target}",
              :sudo => true, :error_check => false)

            if status != 0
              error('not_mounted', src: source, target: target)
            end
          end

          def host
            machine.config.sshfs.host_addr
          end

          def username
            `whoami`.strip
          end

          def password
            Shellwords.escape(@env[:ui].ask(i18n("ask.pass", :user => "#{username}@#{host}"), :echo => false))
          end
        end
      end
    end
  end
end
