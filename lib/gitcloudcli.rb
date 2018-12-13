require "gitcloudcli/version"
require "gitcloudcli/command/space"
require "gitcloudcli/command/config"
require "thor"

module Gitcloudcli
  # 命令行入口
  class Cli < Thor
    desc "list", "展示远端根目录所有文件信息"
    option :space, :desc=>"需要查询的空间"
    option :dir, :desc=>"空间路径"
    option :infos, :desc=>"输出入的文件信息关键字", :type=>:array
    def list()
      Gitcloudcli.gitadapter(options[:space]) do |git|
        git.list(options[:dir], options[:infos])
      end
    end

    desc "info PATH", "展示远端文件信息"
    option :space, :desc=>"需要查询的空间"
    option :infos, :desc=>"输出入的文件信息关键字", :type=>:array
    def info(path)
      Gitcloudcli.gitadapter(options[:space]) do |git|
        git.info(path, options[:infos])
      end
    end

    desc "upload LOCALPATH", "上传本地文件"
    option :space, :desc=>"需要查询的空间"
    option :path, :desc=>"上传的远端路径 example:dirname/filename or filename"
    option :message, :desc=>"本次操作的commit信息"
    option :infos, :desc=>"输出入的文件信息关键字", :type=>:array
    def upload(local_path)
      Gitcloudcli.gitadapter(options[:space]) do |git|
        git.upload(local_path, options[:path], options[:message], options[:infos])
      end
    end

    desc "delete PATH", "删除远端文件"
    option :space, :desc=>"需要查询的空间"
    option :message, :desc=>"本次操作的commit信息"
    def delete(path)
      Gitcloudcli.gitadapter(options[:space]) do |git|
        git.delete(path, options[:message])
      end
    end

    desc "space [COMMAND]", "增加，删除，列出当前可操作的Git空间"
    subcommand "space", Gitcloudcli::CloudSpace
  end
end
