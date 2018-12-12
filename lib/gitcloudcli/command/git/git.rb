module Gitcloudcli
  class Git
    def initialize(url, token) end

    def upload(username, repo, local_path) end

    def url(username, repo, remote_path) end

    def list(username, repo) end

    def delete(username, repo, remote_path, token) end

    def tab_pad(label, tab_stop = 4)
      label_tabs = label.length / 8
      label.ljust(label.length + tab_stop - label_tabs, "\t")
    end
  end
end