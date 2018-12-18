
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gitcloudcli/version"

Gem::Specification.new do |spec|
  spec.name          = "gitcloudcli"
  spec.version       = Gitcloudcli::VERSION
  spec.authors       = ["zhangheng"]
  spec.email         = ["onethousandpiece@126.com"]

  spec.summary       = "git repo's cli"
  spec.description   = "git repo's cli that can create, delete files and other operations"
  spec.homepage      = "https://github.com/monkeyheng/GitCloudCLI"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["gitcloud"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "thor"
end
