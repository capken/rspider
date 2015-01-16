require "rubygems"
require "bundler/setup"

require "curb"
require "logger"
require "json"
require "nokogiri"

CODE_ROOT = File.join(
  File.expand_path(File.dirname(__FILE__)),
  ".."
) unless defined? CODE_ROOT

%w[www cache extractor].each do |dir|
  Dir.glob(File.join(CODE_ROOT, "lib/#{dir}/*.rb")).each do |libname|
    warn "loading ==> #{libname}"
    require libname
  end
end
