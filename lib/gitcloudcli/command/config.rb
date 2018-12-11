require "yaml"

module Gitcloudcli
  class Config
    def initialize(name, url, token)
      @name=name
      @url=url
      @token=token
    end
  end

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

  def configDefult

  end

  module_function :configFile, :configCover, :configHash, :configModels
end