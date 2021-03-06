#
# Fluent
#
# Copyright (C) 2011 FURUHASHI Sadayuki
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
module Fluent


class DebugAgentInput < Input
  Plugin.register_input('debug_agent', self)

  def initialize
    require 'drb/drb'
    super
  end

  config_param :bind, :string, :default => '0.0.0.0'
  config_param :port, :integer, :default => 24230
  config_param :unix_path, :integer, :default => nil
  #config_param :unix_mode  # TODO
  config_param :object, :string, :default => 'Engine'

  def configure(conf)
    super
  end

  def start
    if @unix_path
      require 'drb/unix'
      uri = "drbunix:#{@unix_path}"
    else
      uri = "druby://#{@bind}:#{@port}"
    end
    $log.info "listening dRuby", :uri => uri, :object => @object
    obj = eval(@object)
    @server = DRb::DRbServer.new(uri, obj)
  end

  def shutdown
    @server.stop_service if @server
  end
end


end
