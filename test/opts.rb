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

def parse_flags(opt, flags = [])
  parser.parse(flags) && settings[opt]
end

assert '--port' do
  assert_equal 1974, parse_flags(:port)
  assert_equal 2018, parse_flags(:port, %w[--port 2018])
  assert_equal 2018, parse_flags(:port, %w[-p 2018])
end

assert '--timeout' do
  assert_kind_of Integer, parse_flags(:timeout)
  assert_true parse_flags(:timeout) > 0
  assert_equal 10, parse_flags(:timeout, %w[--timeout 10])
  assert_equal 10, parse_flags(:timeout, %w[-t 10])
end

assert '--environment' do
  assert_equal 'development', parser.parse                  && ENV['SHELF_ENV']
  assert_equal 'test', parser.parse(%w[--environment test]) && ENV['SHELF_ENV']
  assert_equal 'test', parser.parse(%w[-e test])            && ENV['SHELF_ENV']
end

assert '--host' do
  assert_equal 'localhost', parse_flags(:host)
  assert_equal 'localhost', parse_flags(:host, %w[-e test])
  assert_equal '127.0.0.1', parse_flags(:host, %w[--host 127.0.0.1])
  assert_equal '0.0.0.0',   parse_flags(:host, %w[-e production])
  assert_equal '0.0.0.0',   parse_flags(:host, %w[--host host -e production])
  assert_equal 'host',      parse_flags(:host, %w[--host host -e development])
end
