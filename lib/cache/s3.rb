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
      obj = @bucket.objects[hash_of(url)]
      yield obj.read if obj
    end

    def put(url, data, meta)
      compressed_data = Zlib::Deflate.deflate(data)

      obj = @bucket.objects[hash_of(url)]
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
      @bucket.objects[hash_of(url)].exists?
    end

    private

    def hash_of(url)
      Digest::MD5.hexdigest url
    end

  end
end
