require "gitcloudcli/command/git/git"
require 'base64'
require "json"
require "net/http"

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
      response = request(:GET, "https://api.github.com/repos/#{@username}/#{@repo}/contents", nil, nil, nil)
      result = JSON.parse(response.body)
      if block_given?
        yield result
      else
        result.each do |value|
          puts "#{value["name"]}   #{value["download_url"]}  #{value["sha"]}"
        end
      end
    end

    def info(remote_path)
      response = request(:GET, "https://api.github.com/repos/#{@username}/#{@repo}/contents/#{remote_path}",nil, nil, nil)
      result = JSON.parse(response.body)
      puts "#{result["name"]}   #{result["download_url"]}"
    end

    def upload(local_path, filename=nil, message=nil)
      begin
        file = open(local_path)
        content = Base64.encode64(file.read)
      rescue
        puts "#{local_path} 上传失败"
        return
      end

      filename = filename ? filename : local_path.to_s.split("/").last
      message = message ? message : "upload #{filename}"
      paramters={
          "content" => content,
          "message" => message
      }

      response = request(:PUT, "https://api.github.com/repos/#{@username}/#{@repo}/contents/#{filename}?access_token=#{@token}", {"Content-Type" => "text/json"}, nil ,paramters.to_json)
      result = JSON.parse(response.body)
      puts "上传成功：#{filename} #{local_path}"
      puts "download_url:#{result["content"]["download_url"]}"
      puts "sha:#{result["content"]["sha"]}"
    end

    def delete(remote_path)
      sha=nil
      list do |result|
        result.each do |value|
          if value["path"] == remote_path
            sha=value["sha"]
            break
          end
        end
      end
      if !sha
        puts "#{remote_path} 不存在"
        return
      end

      paramters={
          "sha" => sha,
          "message" => "remove #{remote_path}"
      }

      response = request(:DELETE, "https://api.github.com/repos/#{@username}/#{@repo}/contents/#{remote_path}?access_token=#{@token}", {"Content-Type" => "text/json"}, nil ,paramters.to_json)
      if response.code=="200"
        puts "删除 #{remote_path} 成功"
      else
        puts "失败 #{response.body}"
      end
    end
  end
end