require "gitcloudcli/command/git/git"
require "net/http"
require "json"

module Gitcloudcli
  class Github < Git
    def initialize(url, token)
      uri = URI::parse(url)
      result = uri.path.to_s.split("/")
      @username=result[1]
      @repo=result[2].to_s.split(".")[0]
      @token=token
    end

    def list
      uri = URI("https://api.github.com/repos/#{@username}/#{@repo}/contents")
      response = Net::HTTP.get_response(uri)
      result = JSON.parse(response.body)
      result.each do |value|
        puts "#{value["name"].ljust(150)}  #{value["download_url"]}"
      end
    end

    def upload(local_path) end

    def url(remote_path) end

    def delete(remote_path) end
  end
end