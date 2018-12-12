require "yaml"
require "gitcloudcli/command/git/github"

module Gitcloudcli
  def configFile(model="r")
    yaml_dir = Dir.home + "/.gitcloud"
    yaml_name = "gitcloud.yaml"
    if !Dir.exist?(yaml_dir)
      Dir.mkdir(yaml_dir)
    end
    file = File.open(yaml_dir + "/#{yaml_name}", model)
  end

  def configHash
    configs = YAML.load(Gitcloudcli.configFile("r"))
    if !configs
      configs = {}
    end
    return configs
  end

  def configCover(configs)
    YAML.dump(configs, Gitcloudcli.configFile("w"))
  end

  def configModels
    configs = Gitcloudcli.configHash
  end

  def gitadapter(space=nil)
    remote = nil
    token = nil
    configHash.each do |key, value|
      if space
        if key==space
          remote = value["remote"]
          token = value["token"]
          break
        end
      else
        puts "space为空，默认使用#{key}"
        remote = value["remote"]
        token = value["token"]
        break
      end
    end

    if remote
      if remote.to_s.include? "github.com"
        yield Gitcloudcli::Github.new(remote, token)
      else
        puts "#{remote} 不支持"
      end
    else
      puts "#{space} 不不存在"
    end
  end

  module_function :configFile, :configCover, :configHash, :gitadapter
end