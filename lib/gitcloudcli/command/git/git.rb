require "net/http"

module Gitcloudcli
  class Git
    def upload(local_path, filename=nil, message=nil) end

    def info(remote_path) end

    def list() end

    def delete(remote_path) end

    def request(method, urlStr, header, formdata, body)
      if urlStr
        uri = URI.parse(URI.encode(urlStr))
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
      else
        raise "urlStr not give"
      end

      if !header
        header={}
      end

      if method==:GET
        request = Net::HTTP::Get.new(uri.request_uri, header)
      elsif method==:POST
        request = Net::HTTP::Post.new(uri.request_uri, header)
      elsif method==:PUT
        request = Net::HTTP::Put.new(uri.request_uri, header)
      elsif method==:DELETE
        request = Net::HTTP::Delete.new(uri.request_uri, header)
      else
        raise "unsuppose method #{method}"
      end

      if body
        request.body = body
      end
      if formdata
        request.form_data = formdata
      end
      response = http.request(request)
    end
  end
end