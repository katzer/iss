#
# Copyright (c) 2016 by appPlant GmbH. All rights reserved.
#
# @APPPLANT_LICENSE_HEADER_START@
#
# This file contains Original Code and/or Modifications of Original Code
# as defined in and that are subject to the Apache License
# Version 2.0 (the 'License'). You may not use this file except in
# compliance with the License. Please obtain a copy of the License at
# http://opensource.org/licenses/Apache-2.0/ and read it before using this
# file.
#
# The Original Code and all software distributed under the License are
# distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
# EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
# INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
# Please see the License for the specific language governing rights and
# limitations under the License.
#
# @APPPLANT_LICENSE_HEADER_END@

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
