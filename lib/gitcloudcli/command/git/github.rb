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

    def list(dir, infos=[])
      _dir = dir ? dir: ""
      response = request(:GET, "https://api.github.com/repos/#{@username}/#{@repo}/contents/#{_dir}", nil, nil, nil)
      if response.code != "200"
        puts "查询失败 #{dir} #{response.code} #{response.body}"
      elsif block_given?
        yield JSON.parse(response.body)
      else
        result = JSON.parse(response.body)
        result.each do |value|
          puts "每个文件的信息 #{value.keys}"
          break
        end
        result.each do |value|
          if value["type"]=="dir"
            puts "#{value["name"]}/ #{value.values_at(*infos)}"
          else
            puts "#{value["name"]}  #{value["download_url"]} #{value.values_at(*infos)}"
          end
        end
      end
    end

    def info(remote_path, infos=[])
      response = request(:GET, "https://api.github.com/repos/#{@username}/#{@repo}/contents/#{remote_path}",nil, nil, nil)
      if response.code!="200"
        puts "查询失败 #{remote_path} #{response.code} #{response.body}"
      elsif block_given?
        yield JSON.parse(response.body)
      else
        result = JSON.parse(response.body)
        puts "#{result["name"]}   #{result["download_url"]}"
      end
    end

    def upload(local_path, path=nil, message=nil, infos=[])
      file = open(local_path)
      content = Base64.encode64(file.read)
      path = path ? path : local_path.to_s.split("/").last
      message = message ? message : "upload #{path}"
      paramters={
          "content" => content,
          "message" => message
      }
      response = request(:PUT, "https://api.github.com/repos/#{@username}/#{@repo}/contents/#{path}?access_token=#{@token}", {"Content-Type" => "text/json"}, nil ,paramters.to_json)
      if response.code=="201"
        result = JSON.parse(response.body)
        puts "上传成功：#{path} #{local_path}"
        result["content"].each do |key, value|
          if infos and infos.length > 0
            if infos.include? key
              puts "#{key}: #{value}"
            end
          else
            puts "#{key}: #{value}"
          end
        end
      else
        puts "上传失败 #{response.code} #{response.body}"
      end
    end

    def delete(remote_path, message=nil)
      info(remote_path) do |value|
        sha=value["sha"]
        paramters={
            "sha" => sha,
            "message" => message ? message : "remove #{remote_path}"
        }
        response = request(:DELETE, "https://api.github.com/repos/#{@username}/#{@repo}/contents/#{remote_path}?access_token=#{@token}", {"Content-Type" => "text/json"}, nil ,paramters.to_json)
        if response.code!="200"
          puts "删除失败 #{response.code} #{response.body}"
        else
          puts "删除 #{remote_path} 成功"
        end
      end
    end
  end
end