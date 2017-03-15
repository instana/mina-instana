require "rake"
require "mina/instana/version"
require 'net/http'
require 'json'

namespace :instana do
  desc "Send start deploy notification to Instana"
  task :start_deploy do
    comment 'Sending deploy start notification to Instana'

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
    rescue Errno::ECONNREFUSED
      print_error "The Instana host agent isn't running on localhost.  Can't post deploy notifications."
    rescue => e
      print_error "Error posting notification to Instana: #{e.inspect}"
    end
  end

  desc "Send finish deploy notification to Instana"
  task :finish_deploy do
    comment 'Sending deploy finish notification to Instana'

    payload = {}
    repo_name = File.basename(%x[git rev-parse --show-toplevel]).strip
    deployer  = ENV['GIT_AUTHOR_NAME'] || %x[git config user.name].chomp
    revision  = ENV['GIT_COMMIT'] || %x[git rev-parse #{fetch(:branch)}].strip

    payload[:title] = "Deploy finished: #{repo_name}"
    payload[:text] = "#{deployer} finished deploy of #{repo_name}@#{revision[0..7]}"

    begin
      uri = URI('http://127.0.0.1:42699/com.instana.plugin.generic.event')
      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req.body = payload.to_json
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
    rescue Errno::ECONNREFUSED
      print_error "The Instana host agent isn't running on localhost.  Can't post deploy notifications."
    rescue => e
      print_error "Error posting notification to Instana: #{e.inspect}"
    end
  end
end

on :deploy do
  invoke 'instana:finish_deploy'
end

