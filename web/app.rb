require File.expand_path(File.dirname(__FILE__)) + "/../config/load"

require "sinatra"

set :database, {adapter: "sqlite3", database: "db.sqlite3"}

put "/pages/:md5" do
  page = Page.find_by(md5: params[:md5])
  page.update(last_cached_at: Time.now) if page

  status page.nil? ? 404 : 200
  json md5: params[:md5]
end
