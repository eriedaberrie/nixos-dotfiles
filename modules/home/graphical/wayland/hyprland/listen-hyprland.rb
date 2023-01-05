#!/usr/bin/env ruby
# frozen_string_literal: true

require 'socket'

Thread.abort_on_exception = true

SOCK_DIR = "/tmp/hypr/#{ENV['HYPRLAND_INSTANCE_SIGNATURE']}"
SOCK1 = "#{SOCK_DIR}/.socket.sock"
SOCK2 = "#{SOCK_DIR}/.socket2.sock"
SOCK_ = "#{SOCK_DIR}/.personal.sock"

def hyprctl(cmd)
  Socket.unix(SOCK1) do |s|
    s.print cmd
    s.read.force_encoding('UTF-8')
  end
end

def server_listen(server, sig_out)
  while (socket = server.accept)
    while (line = socket.gets)
      case line.chomp
      when 'group_next'
        sig_out[:group_next] = true
      end
    end
  end
ensure
  File.unlink(SOCK_)
end

signals = {}

Thread.new do
  server = UNIXServer.new(SOCK_)
rescue Errno::EADDRINUSE
  puts 'personal sock address in use' rescue nil
else
  server_listen(server, signals)
end

Socket.unix(SOCK2) do |socket|
  while (line = socket.gets)
    event, _, data = line.partition('>>')
    data = data.split(',')
    case event
    when 'openwindow'
      hyprctl 'dispatch togglegroup' if signals.delete(:group_next)
    end
  end
end
