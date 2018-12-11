require "thor"
require "gitcloudcli/command/config"

module Gitcloudcli
    # 空间操作
    class CloudSpace < Thor
        desc "list", "列出当前的Git空间"
        def list
            configs = Gitcloudcli.configHash
            configs.each do |key|
                puts "#{key[0]}  #{key[1]["remote"]}"
            end
        end

        desc "add NAME URL TOKEN", "添加Git空间"
        def add(name, url, token)
            configs = Gitcloudcli.configHash
            if configs[name]
                puts "#{name} 已经存在"
                return
            end
            configs[name] = {
                "remote"=>url,
                "token"=>token
            }
            Gitcloudcli.configCover(configs)
        end

        desc "remove NAME", "删除Git空间"
        def remove(name)
            configs = Gitcloudcli.configHash
            if !configs[name]
                puts "#{name} 不存在"
                return
            end
            configs.delete(name)
            Gitcloudcli.configCover(configs)
        end
    end
end