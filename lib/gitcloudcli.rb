require "gitcloudcli/version"
require "thor"
require "gitcloudcli/command/space"

module Gitcloudcli
  # 命令行入口
  class Cli < Thor
    # def list(space)

    # end

    # def upload(space, path)

    # end

    # def delete(space, filename)

    # end

    # def url(space, filename)

    # end

    desc "space [COMMAND]", "增加，删除，列出当前可操作的Git空间"
    subcommand "space", CloudCommand::CloudSpace
  end
end
