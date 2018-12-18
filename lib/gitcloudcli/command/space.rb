require "thor"
require "gitcloudcli/command/config"

module Gitcloudcli
    # 空间操作
    class CloudSpace < Thor
        desc "list", "show current git spaces"
        def list
            configs = Gitcloudcli.configHash
            configs.each do |key|
                puts "#{key[0]}  #{key[1]["remote"]}"
            end
        end

        desc "add NAME URL TOKEN", "add git space"
        def add(name, url, token)
            configs = Gitcloudcli.configHash
            if configs[name]
                puts "#{name} existed"
                return
            end
            configs[name] = {
                "remote"=>url,
                "token"=>token
            }
            Gitcloudcli.configCover(configs)
        end

        desc "remove NAME", "delete git space"
        def remove(name)
            configs = Gitcloudcli.configHash
            if !configs[name]
                puts "#{name} does not exist"
                return
            end
            configs.delete(name)
            Gitcloudcli.configCover(configs)
        end
    end
end