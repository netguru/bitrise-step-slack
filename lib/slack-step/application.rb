#
#  application.rb
#
#  Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
#

module SlackStep

  class Application

    def initialize(env)
      @env = env
    end

    def run
      client.send(message)
    end

    private

    attr_reader :env

    def client
      @client ||= Client.new(env)
    end

    def message
      @message ||= Message.new(env)
    end

  end

end
