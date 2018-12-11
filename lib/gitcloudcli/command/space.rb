require "thor"
require "yaml"
require "pp"
module CloudCommand
    def configFile(mode="r")
        yaml_dir = Dir.home + "/.gitcloud"
        yaml_name = "gitcloud.yaml"
        if !Dir.exist?(yaml_dir)
            Dir.mkdir(yaml_dir)
        end
        file = File.open(yaml_dir + "/#{yaml_name}", mode)
    end
    module_function :configFile

    # 空间操作
    class CloudSpace < Thor
        desc "space list", "列出当前的Git空间"
        def list
            file = CloudCommand.configFile
            configs = YAML.load(file)
            configs.each do |key|
                puts "#{key[0]}  #{key[1]["remote"]}"
            end
        end

        desc "space add NAME URL", "添加Git空间"
        def add(name, url, token)
            file = CloudCommand.configFile("r+")
            configs = YAML.load(file)
            configs[name] = {
                "remote"=>url,
                "token"=>token
            }
            YAML.dump(configs, file)
        end

        desc "space remove NAME", "删除Git空间"
        def remove(name)
            file = CloudCommand.configFile("w+")
            configs = YAML.load(file)
            configs.delete(name)
            YAML.dump(configs, file)
        end
    end
end