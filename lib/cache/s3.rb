# -*- coding: UTF-8 -*-

module CACHE
  class S3

    DEFAULT_BUCKET = "rspider"

    def initialize(opts = {})
      bucket_name = opts[:bucket] || DEFAULT_BUCKET
      s3 = AWS::S3.new(
        :access_key_id => ENV["AWS_ACCESS_KEY_ID"],
        :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"],
        :region => "us-west-1",
      )
      @bucket = s3.buckets[bucket_name]
    end

    def get(url)
      obj = @bucket.objects[path_of(url)]
      yield obj.read if obj
    end

    def put(url, data, meta)
      compressed_data = Zlib::Deflate.deflate(data)

      obj = @bucket.objects[path_of(url)]
      obj.write(compressed_data, {
        :acl => :public_read,
        :content_encoding => "deflate",
        :content_type => meta["content-type"],
        :metadata => {
          :url => url
        }
      })
    end

    def exists?(url)
      @bucket.objects[path_of(url)].exists?
    end

    private

    def path_of(url)
      uri = URI.parse url
      domain = PublicSuffix.parse(uri.host).domain
      md5 = Digest::MD5.hexdigest url

      "#{domain}/#{md5}"
    end

  end
end
