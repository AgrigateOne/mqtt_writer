# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.17.0'

set :chruby_ruby, 'ruby-2.5.8'

set :application, 'mqtt_writer'
set :repo_url, 'git@github.com:NoSoft-SA/mqtt_writer.git'
set :branch, 'main'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'
append :linked_files, '.env.local', 'mqtt_writer_wrapper.sh', 'crossbeams-mqtt-writer.service'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :chruby_version, -> { fetch(:chruby_ruby) }

namespace :devops do
  desc 'Copy initial files'
  task :copy_initial do
    # set pty: true #### SEE if this solves the sudo cp issue...
    on roles(:app) do |host|
      upload! 'mqtt_writer_wrapper.sh.template', "#{shared_path}/mqtt_writer_wrapper.sh"
      upload! 'crossbeams-mqtt-writer.service.template', "#{shared_path}/crossbeams-mqtt-writer.service"

      execute :sed, "-i 's/$USER/#{host.user}/g' #{shared_path}/crossbeams-mqtt-writer.service"
      execute :sed, "-i 's/$SHARED/#{shared_path.to_s.gsub('/', '\/')}/g' #{shared_path}/crossbeams-mqtt-writer.service"
      execute :sed, "-i 's/$CURRENT/#{current_path.to_s.gsub('/', '\/')}/g' #{shared_path}/crossbeams-mqtt-writer.service"
      execute :sed, "-i 's/$CURRENT/#{current_path.to_s.gsub('/', '\/')}/g' #{shared_path}/mqtt_writer_wrapper.sh"
      execute :sed, "-i 's/$RUBY/#{fetch(:chruby_version)}/g' #{shared_path}/mqtt_writer_wrapper.sh"
      # execute :sed, "-i 's/$RUBY/ruby-2.5.0/g' #{shared_path}/mqtt_writer_wrapper.sh"

      puts('---------------------------------------------------------------------------------------------')
      puts('Now login to the server and copy the service and enable it to start at reboot:')
      puts('sudo cp crossbeams-mqtt-writer.service /etc/systemd/system/crossbeams-mqtt-writer.service')
      puts('sudo systemctl enable crossbeams-mqtt-writer')
      puts('sudo systemctl start crossbeams-mqtt-writer')
      puts('---------------------------------------------------------------------------------------------')

      execute :touch, "#{shared_path}/.env.local"
      # sudo cp /home/nsld/mqtt_writer/shared/crossbeams-mqtt-writer.service /etc/systemd/system/
      # TODO: sudo cp #{shared_path}/crossbeams-mqtt-writer.service /etc/systemd/system/crossbeams-mqtt-writer.service
      # && restart service at end of deploy
      # sudo systemctl restart crossbeams-mqtt-writer.service
    end
  end
end

namespace :deploy do
  after :updated, :restart_service do
    # set pty: true #### SEE if this solves the sudo cp issue...
    on roles(:app) do |_|
      # execute :sudo, :systemctl, 'restart crossbeams-mqtt-writer.service'
      puts('---------------------------------------------------------------------------------------------')
      puts('---')
      puts('--- REMEMBER: Restart the service:: sudo systemctl restart crossbeams-mqtt-writer.service')
      puts('---')
      puts('---------------------------------------------------------------------------------------------')
    end
  end
end
