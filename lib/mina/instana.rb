require "rake"
require "mina/instana/version"
require 'mina/hooks'
require 'net/http'
require 'json'

before_mina :deploy, :'instana:start_deploy' if defined?(before_mina)
after_mina :deploy, :'instana:finish_deploy' if defined?(after_mina)

namespace :instana do
  desc "Send start deploy notification to Instana"
  task :start_deploy do
    comment 'Sending deploy start notification to Instana'

    return if simulate_mode?

    payload = {}
    repo_name = File.basename(%x[git rev-parse --show-toplevel]).strip
    deployer  = ENV['GIT_AUTHOR_NAME'] || %x[git config user.name].chomp
    revision  = ENV['GIT_COMMIT'] || %x[git rev-parse #{branch}].strip

    payload[:title] = "Deploy started: #{repo_name}"
    payload[:text] = "#{deployer} started deploy of #{repo_name}@#{revision[0..7]}"

    begin
      uri = URI('http://127.0.0.1:42699/com.instana.plugin.generic.event')
      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req.body = payload.to_json
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
    rescue => e
      print_error "Error posting notification to Instana: #{e.inspect}"
    end
  end

  desc "Send finish deploy notification to Instana"
  task :finish_deploy do
    comment 'Sending deploy finish notification to Instana'

    return if simulate_mode?

    payload = {}
    repo_name = File.basename(%x[git rev-parse --show-toplevel]).strip
    deployer  = ENV['GIT_AUTHOR_NAME'] || %x[git config user.name].chomp
    revision  = ENV['GIT_COMMIT'] || %x[git rev-parse #{branch}].strip

    payload[:title] = "Deploy finished: #{repo_name}"
    payload[:text] = "#{deployer} finished deploy of #{repo_name}@#{revision[0..7]}"

    begin
      uri = URI('http://127.0.0.1:42699/com.instana.plugin.generic.event')
      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req.body = payload.to_json
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
    rescue
      print_error "Error posting notification to Instana: #{e.inspect}"
    end
  end
end

