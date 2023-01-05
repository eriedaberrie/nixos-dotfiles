#!/usr/bin/env ruby
# frozen_string_literal: true

require 'socket'
require 'json'

$stdout.sync = true

SOCK_DIR = "/tmp/hypr/#{ENV['HYPRLAND_INSTANCE_SIGNATURE']}"
SOCK1 = "#{SOCK_DIR}/.socket.sock"
SOCK2 = "#{SOCK_DIR}/.socket2.sock"

def hyprctl(cmd)
  Socket.unix(SOCK1) do |s|
    s.print cmd
    s.read.force_encoding('UTF-8')
  end
end

class Workspaces
  attr_reader :data

  def initialize
    @active = JSON.parse(hyprctl('j/monitors')).detect { |m| m['focused'] }['activeWorkspace']['id']
    existing = JSON.parse(hyprctl('j/workspaces')).to_h { |w| [w['id'], true]}
    @data = (1..9).map { |id| { id: id, active: id == @active, existing: !!existing[id] } }
  end

  def update_active(workspace)
    update_val(@active, active: false)
    update_val(workspace, active: true)
    @active = workspace
  end

  def update_val(workspace, **kwargs)
    @data[workspace - 1].merge!(kwargs) if workspace.between?(1, 9)
  end
end

class State
  def initialize(**kwargs)
    @data = kwargs
  end

  def update(**kwargs)
    @data.merge!(kwargs)
  end

  def to_s
    JSON.fast_generate(@data)
  end
end

Socket.unix(SOCK2) do |socket|
  ws = Workspaces.new
  state = State.new(
    title: JSON.parse(hyprctl('j/activewindow'))['title'] || '',
    workspaces: ws.data,
  )
  puts state
  while (line = socket.gets)
    event, data = line.split('>>', 2)
    case event
    when 'activewindow'
      state.update(title: data.chomp.split(',', 2).last)
    when 'workspace'
      ws.update_active(data.chomp.to_i)
    when 'focusedmon'
      ws.update_active(data.chomp.split(',', 2).last.to_i)
    when 'createworkspace'
      ws.update_val(data.chomp.to_i, existing: true)
    when 'destroyworkspace'
      ws.update_val(data.chomp.to_i, existing: false)
    else
      next
    end
    puts state
  end
end
