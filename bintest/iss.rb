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

require 'open3'
require_relative '../mrblib/iss/version'

ENV['ORBIT_HOME'] = __dir__
ENV['ORBIT_FILE'] = File.expand_path('config/orbit.json', __dir__)

BINARY = File.expand_path('../mruby/bin/iss', __dir__)

%w[-v --version].each do |flag|
  assert("version [#{flag}]") do
    output, status = Open3.capture2(BINARY, flag)

    assert_true status.success?, 'Process did not exit cleanly'
    assert_include output, ISS::VERSION
  end
end

%w[-h --help].each do |flag|
  assert("usage [#{flag}]") do
    output, status = Open3.capture2(BINARY, flag)

    assert_true status.success?, 'Process did not exit cleanly'
    assert_include output, 'Usage'
  end
end

%w[-p --port].each do |flag|
  assert("usage [#{flag}]") do
    _, output, status = Open3.popen2(BINARY, flag, '8889')

    assert_include output.gets, 'http://localhost:8889'
  ensure
    Process.kill :KILL, status.pid
  end
end

%w[-e --environment].each do |flag|
  assert("usage [#{flag}]") do
    _, out, status = Open3.popen2(BINARY, flag, 'production')
    output         = out.gets

    assert_include output, 'production'
    assert_include output, '0.0.0.0'
  ensure
    Process.kill :KILL, status.pid
  end
end

%w[-t --timeout -c --cleanup].each do |flag|
  assert("usage [#{flag}]") do
    _, output, status = Open3.capture3(BINARY, flag, '0')

    assert_false status.success?, 'Process did exit cleanly'
    assert_include output, 'cannot be zero'
  end
end

assert('usage [-r]') do
  output, status = Open3.capture2(BINARY, '-r')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'GET /'
end

assert('usage [--routes]') do
  output, status = Open3.capture2(BINARY, '--routes')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'GET /'
end

assert('usage [--host]') do
  _, output, status = Open3.popen2(BINARY, '--host', '0.0.0.0')

  assert_include output.gets, 'http://0.0.0.0:'
ensure
  Process.kill :KILL, status.pid
end

assert('unknown flag') do
  _, output, status = Open3.capture3(BINARY, '-unknown')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'unknown option'
end
