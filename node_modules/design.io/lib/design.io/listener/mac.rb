require 'rubygems'
require 'rb-fsevent'

fsevent     = FSEvent.new
STDOUT.sync = true
io          = STDOUT
directory   = ARGV[0]

#directory   = STDIN.read
fsevent.watch directory do |directories|
  io.write directories.inspect
end
fsevent.run
