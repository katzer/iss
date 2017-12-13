# Apache 2.0 License
#
# Copyright (c) Copyright 2016 Sebastian Katzer, appPlant GmbH
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

def env_for(path, query = '')
  { 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => path, 'QUERY_STRING' => query }
end

def fixture(file)
  File.read File.join(File.dirname(__FILE__), "../fixtures/#{file}").chomp
end

def override_fifa(status = 0)
  ISS::Fifa.define_method(:exec) { |cmd| [yield(cmd).split("\n"), status == 0] }
end

def override_ski(status = 0)
  ISS::Ski.define_method(:exec) { |cmd| [yield(cmd).split("\n"), status == 0] }
end

def configure_tools
  override_fifa do |cmd|
    fixture(cmd.include?('-a=') ? 'planet_ids.txt' : 'planets.txt')
  end

  override_ski do |cmd|
    fixture(cmd.include?('-c="cat') ? 'file.txt' : 'files.txt')
  end
end

def api_call(url, query = '')
  app.call env_for("/api/#{url}", query)
end

def api_call!(url, query = '')
  configure_tools
  api_call(url, query)
end

assert 'GET /api/lfv/planets' do
  override_fifa { fixture('planets.txt') }
  code, headers, body = api_call('lfv/planets')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal fixture('planets.json'), body[0]
end

assert 'GET /api/lfv/planets/files' do
  code, headers, body = api_call!('lfv/planets/localhost/files')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal fixture('files.json'), body[0]
end

assert 'GET /api/lfv/planets/files', 'when server is unknown' do
  code, = api_call!('lfv/planets/unknown/files')

  assert_equal 404, code
end

assert 'GET /api/lfv/planets/file' do
  code, headers, body =
    api_call!('lfv/planets/localhost/file', 'file_id=%2Flog%2Ffile1.txt')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal fixture('file.json'), body[0]
end

assert 'GET /api/lfv/planets/file', 'when server is unknown' do
  code, = api_call!('lfv/planets/unknown/file', 'file_id=test.log')

  assert_equal 404, code
end

assert 'GET /api/lfv/planets/file', 'when file is unknown' do
  code, = api_call!('lfv/planets/localhost/file', 'file_id=unknown.log')

  assert_equal 404, code
end

assert 'GET /api/lfv/planets/file', 'when file_id is missing' do
  code, = api_call!('lfv/planets/unknown/file')

  assert_equal 404, code
end

assert 'GET /api/lfv/planets/file', 'when file is bad' do
  code, = api_call!('lfv/planets/localhost/file', 'file_id="rm -rf *"')

  assert_equal 400, code
end
