# frozen_string_literal: true

# GHS - Goede Hoop Sitrus
server '192.168.6.31', user: 'nsprint', roles: %w[app db web]
set :deploy_to, '/home/nsprint/mqtt_writer'
# set :chruby_ruby, 'ruby-2.5.8'
