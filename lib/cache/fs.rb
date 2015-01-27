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
      end
    end

    def put(url, data, meta)
      File.open(path_of(url), 'w') do |file|
        file.puts data
      end
    end

    def exists?(url)
      File.exists? path_of(url)
    end

    private

    def hash_of(url)
      Digest::MD5.hexdigest url
    end

    def path_of(url)
      File.join @bucket_path, hash_of(url)
    end

  end
end
