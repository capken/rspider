
Page.delete_all
Job.delete_all
Task.delete_all

page_ids = []

# import pages
seeds_file = File.join(File.dirname(__FILE__), 'sample.urls.txt')
File.readlines(seeds_file).each do |line|
  url = line.strip
  uri = URI.parse url
  
  page = Page.new do |p|
    p.url = url
    p.md5 = Digest::MD5.hexdigest url
    p.domain = PublicSuffix.parse(uri.host).domain
  end

  page.save

  page_ids << page.id
end

# create one job
#job = Job.new do |j|
#  j.name = 'sample_job'
#end
#job.save
#
#page_ids.each do |page_id|
#  job.tasks.create(
#    page_id: page_id,
#    status: 'created'
#  )
#end
