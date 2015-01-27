# -*- coding: UTF-8 -*-

module CACHE
  class Base

    def self.create(opts = {})
      case opts[:storage]
      when :s3
        S3.new opts
      when :fs
        FileSystem.new opts
      end
    end

  end
end
