module Gitcloudcli
  class Git
    def initialize(url, token) end

    def upload(username, repo, local_path) end

    def url(username, repo, remote_path) end

    def list(username, repo) end

    def delete(username, repo, remote_path, token) end
  end
end