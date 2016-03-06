#
#  environment.rb
#
#  Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
#

module SlackStep

  class Environment

    def initialize(nenv)
      @nenv = nenv
    end

    def build_number
      @nenv.bitrise_build_number
    end

    def build_url
      @nenv.bitrise_build_url
    end

    def build_successful?
      !@nenv.bitrise_build_status?
    end

    def git_commit
      @nenv.git_clone_commit_hash[0...7]
    end

    def git_message
      @nenv.git_clone_commit_message_subject
    end

    def git_author
      @nenv.git_clone_commit_author
    end

    def git_branch
      @nenv.bitrise_git_branch
    end

    def jira_domain
      @nenv.jira_domain
    end

    def jira_project_key
      @nenv.jira_project_key
    end

    def jira_task
      git_branch.split("/").last.split("-").each_cons(2).to_a.each do |comps|
        if comps[0].downcase == jira_project_key.downcase && comps[1].is_numeric?
          return "#{comps[0]}-#{comps[1]}".upcase
        end
      end
    end

    def slack_webhook_url
      ENV["webhook_url"] || @nenv.slack_webhook_url
    end

    def slack_channel
      ENV["channel"] || @nenv.slack_channel
    end

    def slack_username
      "Bitrise"
    end

    def slack_icon_emoji
      ":bitrise:"
    end

    def xcode_scheme
      @nenv.bitrise_scheme
    end

  end

end
