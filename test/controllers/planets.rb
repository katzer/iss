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

Yeah.application.initialize!
Yeah.application.settings[:lfv][:planets] = 'otherhost'

def env_for(path, query = '')
  { 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => path, 'QUERY_STRING' => query }
end

def api_call(url, query = '')
  Yeah.application.app.call env_for(url, query)
end

def `(cmd)
  case cmd
  when "fifa -f=json 'id:.*'"
    %({"id":"localhost","name":"name","host":"host","type":"server"}\n{"id":"otherhost","name":"name","host":"host","type":"db"}\n)
  when "fifa -f=json 'id=localhost'"
    %({"id":"localhost","name":"name","host":"host","type":"server"}\n)
  when "fifa -f=json 'otherhost'"
    %({"id":"otherhost","name":"name","host":"host","type":"server"}\n)
  else
    ''
  end
ensure
  $? = 0
end

assert 'GET /planets' do
  code, headers, body = api_call('/planets')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal "[#{`fifa -f=json 'id:.*'`.chomp.sub("\n", ',')}]", body[0]
end

assert 'GET /planets?scope=lfv' do
  code, headers, body = api_call('/planets', 'scope=lfv')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal "[#{`fifa -f=json 'otherhost'`.chomp}]", body[0]
end

assert 'GET /planets/{id}' do
  code, headers, body = api_call('/planets/localhost')

  assert_equal 200, code
  assert_include headers['Content-Type'], 'application/json'
  assert_equal `fifa -f=json 'id=localhost'`.chomp, body[0]
end
