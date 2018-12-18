require "gitcloudcli/version"
require "gitcloudcli/command/space"
require "gitcloudcli/command/config"
require "gitcloudcli/version"
require "thor"

module Gitcloudcli
  # 命令行入口
  class Cli < Thor
    desc "list", "show all files in the remote"
    option :space, :desc=>"git space name"
    option :dir, :desc=>"the dir of files that need show"
    option :infos, :desc=>"the key of this file infos that printed", :type=>:array
    def list()
      Gitcloudcli.gitadapter(options[:space]) do |git|
        git.list(options[:dir], options[:infos])
      end
    end

    desc "info PATH", "get the remote file infos"
    option :space, :desc=>"git space name"
    option :infos, :desc=>"the key of this file infos that printed", :type=>:array
    def info(path)
      Gitcloudcli.gitadapter(options[:space]) do |git|
        git.info(path, options[:infos])
      end
    end

    desc "upload LOCALPATH", "upload local file"
    option :space, :desc=>"git space name"
    option :path, :desc=>"upload path. example:dirname/filename or filename"
    option :message, :desc=>"commit info for this operation"
    option :infos, :desc=>"the key of this file infos that printed", :type=>:array
    def upload(local_path)
      Gitcloudcli.gitadapter(options[:space]) do |git|
        git.upload(local_path, options[:path], options[:message], options[:infos])
      end
    end

    desc "delete PATH", "delete file"
    option :space, :desc=>"git space name"
    option :message, :desc=>"commit info for this operation"
    def delete(path)
      Gitcloudcli.gitadapter(options[:space]) do |git|
        git.delete(path, options[:message])
      end
    end

    map %w[--version -v] => :__print_version
    desc "--version, -v", "print the version"
    def __print_version
      puts Gitcloudcli::VERSION
    end

    desc "space [COMMAND]", "manage git space"
    subcommand "space", Gitcloudcli::CloudSpace
  end
end
