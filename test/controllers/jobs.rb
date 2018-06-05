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

def env_for(path, query = '')
  { 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => path, 'QUERY_STRING' => query }
end

def fixture(file)
  File.read File.join(File.dirname(__FILE__), "../fixtures/#{file}.json").chomp
end

def api_call(url)
  Yeah.application.app.call env_for(url)
end

assert 'GET /jobs' do
  code, headers, body = api_call('/jobs')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal fixture('jobs'), body[0]
end

assert 'GET /jobs/reports' do
  code, headers, body = api_call('/jobs/showver/reports')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal fixture('reports'), body[0]
end

assert 'GET /jobs/reports', 'missing reports sub folder' do
  code, headers, body = api_call('/jobs/hostname/reports')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal '[]', body[0]
end

assert 'GET /jobs/reports', 'missing job' do
  assert_equal 404, api_call('/jobs/reports')[0]
end

assert 'GET /jobs/reports', 'unknown job' do
  assert_equal 404, api_call('/jobs/123/reports')[0]
end

assert 'GET /jobs/reports/results' do
  job = '/jobs/showver/reports/2017-05-12T10_29_03/results'
  code, headers, body = api_call(job)

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal fixture('results'), body[0]
end

assert 'GET /jobs/reports/results', 'unknown job' do
  assert_equal 404, api_call('/jobs/123/reports/2017-05-12T10_29_03/results')[0]
end

assert 'GET /jobs/reports/results', 'unknown report' do
  assert_equal 404, api_call('/jobs/showver/reports/123/results')[0]
end
