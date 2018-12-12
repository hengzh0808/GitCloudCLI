require "gitcloudcli/version"
require "gitcloudcli/command/space"
require "gitcloudcli/command/config"
require "thor"

module Gitcloudcli
  # 命令行入口
  class Cli < Thor
    desc "list", "list"
    def list
      Gitcloudcli.gitadapter(nil) do |git|
        git.list
      end
    end

    desc "upload", "upload"
    def upload(path, filename=nil, message=nil)
      Gitcloudcli.gitadapter(nil) do |git|
        git.upload(path, filename, message)
      end
    end

    desc "delete", "delete"
    def delete(remote_path)
      Gitcloudcli.gitadapter(nil) do |git|
        git.delete(remote_path)
      end
    end

    desc "info", "info"
    def info(remote_path)
      Gitcloudcli.gitadapter(nil) do |git|
        git.info(remote_path)
      end
    end

    desc "space [COMMAND]", "增加，删除，列出当前可操作的Git空间"
    subcommand "space", Gitcloudcli::CloudSpace
  end
end
