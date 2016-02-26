#
#  step.rb
#
#  Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
#

require 'net/http'
require 'json'

# Functions

def build_successful?(build_status)
  return build_status == "0" || build_status == 0 || build_status == false
end

def jira_task_id_from_branch_name(branch_name, project_key)
  branch_name.split("/").last.split("-").each_cons(2).to_a.each do |comps|
    if comps[0].downcase == project_key.downcase && comps[1].is_numeric?
      return "#{comps[0]}-#{comps[1]}".upcase
    end
  end
  return nil
end

def slack_build_status_title(build_status)
  if build_successful?(build_status)
    return "Build succeeded"
  else
    return "Build failed"
  end
end

# Extensions

class String
  def is_numeric?
    Float(self) != nil rescue false
  end
end

# Environmental variables

bitrise_build_number = ENV["BITRISE_BUILD_NUMBER"]
bitrise_build_status = ENV["BITRISE_BUILD_STATUS"]
bitrise_build_url = ENV["BITRISE_BUILD_URL"]

git_commit_sha = (ENV["GIT_CLONE_COMMIT_HASH"])[0...8]
git_commit_message = ENV["GIT_CLONE_COMMIT_MESSAGE_SUBJECT"]
git_author = ENV["GIT_CLONE_COMMIT_AUTHOR_NAME"]
git_branch = ENV["BITRISE_GIT_BRANCH"]

xcode_scheme = ENV["BITRISE_XCODE_SCHEME"]

jira_domain = ENV["JIRA_DOMAIN"]
jira_project_key = ENV["JIRA_PROJECT_KEY"]

slack_webhook_url = ENV["webhook_url"]
slack_channel = ENV["channel"]
slack_username = ENV["username"]
slack_avatar_success = ENV["avatar_success"]
slack_avatar_failure = ENV["avatar_failure"]

jira_task_id = jira_task_id_from_branch_name(git_branch, jira_project_key)

# Slack Color

slack_color = build_successful?(bitrise_build_status) ? "good" : "danger"

# Title

slack_title = ""

slack_title << "*" << slack_build_status_title(bitrise_build_status) << "*: "
slack_title << "<#{bitrise_build_url}|##{bitrise_build_number}> "
slack_title << "(#{git_commit_sha} by #{git_author} on #{git_branch})"

# Fallback

slack_fallback = ""

slack_fallback << slack_build_status_title(bitrise_build_status) << ": ##{bitrise_build_number} "
slack_fallback << "(#{git_commit_sha} by #{git_author} on #{git_branch}) "
slack_fallback << bitrise_build_url

# Fields

slack_fields = []

unless git_commit_message.nil?
  slack_fields.push({
    title: "Commit",
    value: git_commit_message,
    short: false
  })
end

unless jira_domain.nil? || jira_task_id.nil?
  slack_fields.push({
    title: "Task",
    value: "<https://#{jira_domain}.atlassian.net/browse/#{jira_task_id}|#{jira_task_id}>",
    short: true
  })
end

unless xcode_scheme.nil?
  slack_fields.push({
    title: "Scheme",
    value: xcode_scheme,
    short: true
  })
end

# Composition

slack_payload = {
  attachments: [{
    fallback: slack_fallback,
    text: slack_title,
    fields: slack_fields,
    color: slack_color,
    mrkdwn_in: ["text"]
  }],
  channel: slack_channel,
  username: slack_username
}

# Delivery

slack_webhook_uri = URI.parse(slack_webhook_url)

slack_client = Net::HTTP.new(slack_webhook_uri.host, slack_webhook_uri.port)
slack_client.use_ssl = true

slack_request = Net::HTTP::Post.new(slack_webhook_uri)
slack_request.content_type = "application/json"
slack_request.body = slack_payload.to_json

slack_response = slack_client.request(slack_request)

# Exit

if slack_response.code == 200
  ENV["SLACK_WEBHOOK_STATUS"] = "success"
  exit 0
else
  ENV["SLACK_WEBHOOK_STATUS"] = "failure"
  exit 1
end
