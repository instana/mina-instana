require "mina/instana/version"
require 'mina/hooks'
require 'net/http'

set_default :instana_host, :localhost
set_default :instana_port, 42699
set_default :instana_url,  'com.instana.plugin.generic.event'
set_default :repo_name,             -> { File.basename(%x[git rev-parse --show-toplevel]) }
set_default :deployer,              -> { ENV['GIT_AUTHOR_NAME'] || %x[git config user.name].chomp }
set_default :deployed_revision,     -> { ENV['GIT_COMMIT'] || %x[git rev-parse #{branch}].strip }

before_mina :deploy, :'instana:start_deploy'
after_mina :deploy, :'instana:finish_deploy'

namespace :instana do
  desc "Send start deploy notification to Instana"
  task :start_deploy do
		comment 'Sending deploy start notification to Instana'

		return if simulate_mode?

    payload = {}
    payload[:title] = "Deploy started: #{repo_name}"
    payload[:text] = "#{deployer} started deploy of #{repo_name}@#{revision}"

		begin
			uri = URI("http://#{instana_host}:#{instana_port}/#{instana_url}")
			req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
			req.body = payload.to_json
			Net::HTTP.start(uri.hostname, uri.port) do |http|
				http.request(req)
			end
		rescue
      # Do nothing - failures shouldn't break anything
		end
  end

  desc "Send finish deploy notification to Instana"
  task :finish_deploy do
		comment 'Sending deploy finish notification to Instana'

		return if simulate_mode?

    payload = {}
    payload[:title] = "Deploy finished: #{repo_name}"
    payload[:text] = "#{deployer} finished deploy of #{repo_name}@#{revision}"

		begin
			uri = URI("http://#{instana_host}:#{instana_port}/#{instana_url}")
			req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
			req.body = payload.to_json
			Net::HTTP.start(uri.hostname, uri.port) do |http|
				http.request(req)
			end
		rescue
      # Do nothing - failures shouldn't break anything
		end
  end
end

