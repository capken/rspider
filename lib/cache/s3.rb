# -*- coding: UTF-8 -*-

module CACHE
  class S3

    DEFAULT_BUCKET = "rspider"

    def initialize(opts = {})
      bucket_name = CONFIG[:s3_bucket] || DEFAULT_BUCKET
      s3 = AWS::S3.new(
        :access_key_id => ENV["AWS_ACCESS_KEY_ID"],
        :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"],
        :region => CONFIG[:s3_region]
      )
      @bucket = s3.buckets[bucket_name]
    end

    def get(url)
      obj = @bucket.objects[path_of(url)]
      #TODO: use the encoding info in object meta
      yield Zlib::Inflate.inflate(obj.read).force_encoding('UTF-8') if obj
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
      page_url = WWW::URL.new url
      "#{page_url.domain}/#{page_url.md5}"
    end

  end
end
