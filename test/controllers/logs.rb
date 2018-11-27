# Apache 2.0 License
#
# Copyright (c) 2016 Sebastian Katzer, appPlant GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

@file_id = __FILE__.gsub('/', '~')

Yeah.application.settings[:lfv] = {
  planets: 'localhost otherhost',
  files: [["#{File.dirname(__FILE__)}/{logs,stats}.rb", 16]],
  timestamps: [[__FILE__, 0, 'Copyright', 16, 4, 'Y']]
}

Yeah.application.opts.parser.parse([])

def env_for(path, query = '')
  { 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => path, 'QUERY_STRING' => query }
end

def api_call(url, query = '')
  Yeah.application.app.call env_for(url, query)
end

def `(cmd)
  case cmd
  when 'fifa -n -f json localhost' then %({"id":"localhost","type":"server"}\n)
  when 'fifa -n -f ssh localhost'  then "root@localhost\n"
  when 'fifa -n -a id localhost'   then "localhost\n"
  when 'fifa -n -a id otherhost'   then "otherhost\n"
  else ''
  end
ensure
  $? = cmd == 'fifa -n -f json otherhost' ? 1 : 0
end

assert 'GET /planets/{id}/logs' do
  code, headers, body = api_call('/planets/localhost/logs')
  logs                = JSON.parse(body[0])

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'

  assert_equal 2,                   logs.size
  assert_equal @file_id,            logs.first[0]
  assert_equal 'localhost',         logs.first[1]
  assert_equal __FILE__,            logs.first[3]
  assert_equal File.size(__FILE__), logs.first[4]
  assert_kind_of Integer,           logs.first[5]
rescue RuntimeError => e
  ENV['OS'] == 'Windows_NT' ? skip : raise(e)
end

assert 'GET /planets/{id}/logs', 'when server is unknown' do
  assert_equal 404, api_call('/planets/unknown/logs')[0]
end

assert 'GET /planets/{id}/logs', 'when fifa fails' do
  assert_raise(RuntimeError) { api_call('/planets/otherhost/logs') }
end

assert 'GET /planets/localhost/logs/{path}' do
  code, headers, body = \
    api_call("/planets/localhost/logs/#{@file_id}")

  lines  = JSON.parse(body[0])
  readme = File.read(__FILE__).chomp.split("\n")

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_not_include headers, 'Cache-Control'

  assert_equal @file_id,     lines.first[0]
  assert_equal 'localhost',  lines.first[1]
  assert_equal 1,            lines.first[2]
  assert_equal readme.first, lines.first[3]
  assert_equal %w[2016 Y],   lines[2][4]
  assert_equal lines[3][4],  lines[2][4]
  assert_equal readme.count, lines.count
rescue RuntimeError => e
  ENV['OS'] == 'Windows_NT' ? skip : raise(e)
end

assert 'GET /planets/localhost/logs/{path}', '?size=int' do
  code, headers, body = \
    api_call("/planets/localhost/logs/#{@file_id}", 'size=3')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_not_include headers, 'Cache-Control'

  assert_equal IO.read(__FILE__)[0, 3].strip, JSON.parse(body[0]).first[3]
rescue RuntimeError => e
  ENV['OS'] == 'Windows_NT' ? skip : raise(e)
end

assert 'GET /planets/localhost/logs/{path}', '?size=-int' do
  code, headers, body = \
    api_call("/planets/localhost/logs/#{@file_id}", 'size=-3')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_not_include headers, 'Cache-Control'

  assert_equal IO.read(__FILE__)[-3, 3].strip, JSON.parse(body[0]).first[3]
rescue RuntimeError => e
  ENV['OS'] == 'Windows_NT' ? skip : raise(e)
end

assert 'GET /planets/localhost/logs/{path}', 'when path is not found' do
  assert_equal 404, api_call("/planets/localhost/logs/#{@file_id}x}")[0]
rescue RuntimeError => e
  ENV['OS'] == 'Windows_NT' ? skip : raise(e)
end

assert 'GET /planets/localhost/logs/{path}', 'when path does not match' do
  assert_equal 404, api_call('/planets/localhost/logs/logs.rb')[0]
end
