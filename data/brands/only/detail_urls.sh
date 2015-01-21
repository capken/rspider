`dirname $0`/list_urls.sh |
`dirname $0`/../../../bin/link ".HfloorTwoListTitle a" |
ruby -ne "
  url = \$_.strip
  if url =~ /\d+\.html$/
    puts url
  elsif url =~ /productId=(\d+)/
    puts \"http://www.only.cn/cn/onlystore/#{\$1}.html\"
  end
" | sort -u
