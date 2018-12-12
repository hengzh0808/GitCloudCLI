require "gitcloudcli/version"
require "gitcloudcli/command/space"
require "gitcloudcli/command/config"
require "thor"

module Gitcloudcli
  # 命令行入口
  class Cli < Thor
    desc "list", "展示远端根目录所有文件信息"
    option :infos, :desc=>"输出入的文件信息关键字", :type=>:array
    def list
      Gitcloudcli.gitadapter(nil) do |git|
        git.list(options[:infos])
      end
    end

    desc "info", "展示远端文件信息"
    option :infos, :desc=>"输出入的文件信息关键字", :type=>:array
    def info(remote_path)
      Gitcloudcli.gitadapter(nil) do |git|
        git.info(remote_path, options[:infos])
      end
    end

    desc "upload PATH", "upload"
    option :filename, :desc=>"自定义远端文件名"
    option :message, :desc=>"上传信息"
    def upload(path)
      Gitcloudcli.gitadapter(nil) do |git|
        git.upload(path, options[:filename], options[:message])
      end
    end

    desc "delete", "delete"
    def delete(remote_path)
      Gitcloudcli.gitadapter(nil) do |git|
        git.delete(remote_path)
      end
    end

    desc "space [COMMAND]", "增加，删除，列出当前可操作的Git空间"
    subcommand "space", Gitcloudcli::CloudSpace
  end
end
