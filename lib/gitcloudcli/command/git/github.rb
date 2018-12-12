require "gitcloudcli/command/git/git"
require "json"
require 'base64'

require "net/http"
require 'rest-client'

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
        puts "#{value["name"]}   #{value["download_url"]}  #{value["sha"]}"
        # puts "#{tab_pad(value["name"])}#{value["download_url"]}"
      end
    end

    def upload(local_path, message=nil)
      file = open(local_path)
      content = Base64.encode64(file.read)
      filename = local_path.to_s.split("/").last
      message = message ? message : filename

      header={
          "Content-Type" => "text/json"
      }
      paramters={
          "content" => content,
          "message" => message
      }
      uri = URI.parse("https://api.github.com/repos/#{@username}/#{@repo}/contents/#{filename}?access_token=#{@token}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      puts uri.path
      puts uri.request_uri
      request = Net::HTTP::Put.new(uri.request_uri, header)
      request.body = paramters.to_json

      response = http.request(request)
      result = JSON.parse(response.body)
      puts "download_url:#{result["content"]["download_url"]}"
      puts "sha:#{result["content"]["sha"]}"
    end

    def url(remote_path)
      uri = URI(URI::encode("https://api.github.com/repos/#{@username}/#{@repo}/contents/#{remote_path}"))
      response = Net::HTTP.get_response(uri)
      result = JSON.parse(response.body)
      puts "#{result["name"]}   #{result["download_url"]}"
    end

    def delete(remote_path)
      paramters={
          "sha"=>"4b38ed11d518f0d76556fd51930ed407ae007d95",
          "message"=>"remove a file",
      }
      data = URI.encode_www_form(paramters)
      http = Net::HTTP.new("api.github.com")
      response = http.send_request("DELETE", "/repos/#{@username}/#{@repo}/contents/1111111111111111.png/?access_token=#{@token}")
      puts response.body
      result = JSON.parse(response.body)
      puts result
      # "message": "delete a file",
      #     "sha": "46d2b1f2ef54669a974165d0b37979e9adba1ab2"
    end
  end
end