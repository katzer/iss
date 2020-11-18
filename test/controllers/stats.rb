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

def `(cmd)
  if cmd.split('=').size > 3
    "41\n82\n84\n85\n"
  elsif cmd.include? ' -c '
    "41\n"
  else
    "planet@1\nplanet@2\n"
  end
ensure
  $? = 0
end

def api_call(url, query = '')
  Yeah.application.app.call env_for(url, query)
end

assert 'GET /stats' do
  code, headers, body = api_call('/stats')

  result = [
    ['server', 'Instances', 41], ['db', 'Databases', 82],
    ['web', 'Webserver', 84], ['tool', 'Tools', 85]
  ]

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal result, JSON.parse(body[0])
end

assert 'GET /stats/{type}/count' do
  code, headers, body = api_call('/stats/server/count')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal '41', body[0]
end

assert 'GET /stats/{type}/list' do
  code, headers, body = api_call('/stats/server/list')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal '["planet@1","planet@2"]', body[0]
end
