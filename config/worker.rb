require "rubygems"
require "bundler/setup"

require "curb"
require "logger"
require "json"
require "zlib"
require "aws-sdk-v1"
require "nokogiri"
require "public_suffix"

CODE_ROOT = File.join(
  File.expand_path(File.dirname(__FILE__)),
  ".."
) unless defined? CODE_ROOT

STORAGE = :s3

%w[www cache jobs].each do |dir|
  Dir.glob(File.join(CODE_ROOT, "lib/#{dir}/*.rb")).each do |libname|
    warn "loading ==> #{libname}"
    require libname
  end
end
