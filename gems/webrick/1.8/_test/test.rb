# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "webrick"

root = File.expand_path '~/public_html'
server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root

newProc = Proc.new do |req, res|
  res.body = 'Hello, test!'
end
server.mount_proc '/test', newProc
server.mount_proc '/' do |req, res|
  res.body = 'Hello, world!'
end
server.start
