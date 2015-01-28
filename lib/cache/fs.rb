# -*- coding: UTF-8 -*-

module CACHE
  class FileSystem

    DEFAULT_BUCKET = 'cache'

    def initialize(opts = {})
      @bucket = opts[:bucket] || DEFAULT_BUCKET

      @bucket_path = File.join CODE_ROOT, @bucket
      FileUtils.mkdir_p(@bucket_path) unless Dir.exists? @bucket_path
    end

    def get(url)
      File.open(path_of(url)) do |file|
        yield file.read
      end if exists?(url)
    end

    def put(url, data, meta)
      path = path_of url

      dir = File.dirname path
      FileUtils.mkdir_p(dir) unless Dir.exists? dir

      File.open(path, 'w') do |file|
        file.puts data
      end
    end

    def exists?(url)
      File.exists? path_of(url)
    end

    private

    def path_of(url)
      page_url = WWW::URL.new url
      File.join @bucket_path, page_url.domain, page_url.md5
    end

  end
end
