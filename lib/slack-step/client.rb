#
#  client.rb
#
#  Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
#

module SlackStep

  class Client

    def initialize(env)
      @env = env
    end

    def send(message)
      slack_notifier.ping({
        attachments: [{
          fallback: message.fallback,
          text: message.title,
          fields: message.fields.map { |field|
            field.replace(:value, Slack::Notifier::LinkFormatter.format(field[:value]))
          },
          color: message.border_color,
          mrkdwn_in: [:text]
        }],
      }).code.to_i.between?(200, 299)
    end

    private

    def slack_notifier
      @slack_notifier ||= Slack::Notifier.new(@env.slack_webhook_url, {
        channel: @env.slack_channel,
        username: @env.slack_username,
        icon_emoji: @env.slack_icon_emoji,
      })
    end

  end

end
