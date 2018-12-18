require "yaml"
require "gitcloudcli/command/git/github"

module Gitcloudcli
  def configFile(model="r")
    yaml_dir = Dir.home + "/.gitcloudcli"
    yaml_name = "gitcloud.yaml"
    yaml_path = yaml_dir + "/#{yaml_name}"
    if !Dir.exist?(yaml_dir)
      Dir.mkdir(yaml_dir)
    end
    if !File.exist? yaml_path
      File.open(yaml_path, 'w').close
    end
    file = File.open(yaml_path, model)
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
          space = key
          break
        end
      else
        puts "SPACE is null，use default #{key}"
        remote = value["remote"]
        token = value["token"]
        break
      end
    end

    if remote
      if remote.to_s.include? "github.com"
        yield Gitcloudcli::Github.new(remote, token)
      else
        puts "#{space} #{remote} not supported"
      end
    else
      puts "git space is empty"
    end
  end

  module_function :configFile, :configCover, :configHash, :gitadapter
end