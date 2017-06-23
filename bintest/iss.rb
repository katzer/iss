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

require 'open3'
require_relative '../mrblib/version'

ENV['ORBIT_HOME'] = __dir__
ENV['ORBIT_FILE'] = File.expand_path('config/orbit.json', __dir__)

BINARY = File.expand_path('../mruby/bin/iss', __dir__)

assert('version [-v]') do
  output, status = Open3.capture2(BINARY, '-v')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, ISS::VERSION
end

assert('version [--version]') do
  output, status = Open3.capture2(BINARY, '--version')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, ISS::VERSION
end

assert('usage [-h]') do
  output, status = Open3.capture2(BINARY, '-h')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'usage'
end

assert('usage [--help]') do
  output, status = Open3.capture2(BINARY, '--help')

  assert_true status.success?, 'Process did not exit cleanly'
  assert_include output, 'usage'
end

assert('usage [--port]') do
  begin
    _, output, status = Open3.popen2(BINARY, '--port', '8888')

    assert_include output.gets, 'http://localhost:8888'
  ensure
    Process.kill :KILL, status.pid
  end
end

assert('usage [-p]') do
  begin
    _, output, status = Open3.popen2(BINARY, '-p', '8889')

    assert_include output.gets, 'http://localhost:8889'
  ensure
    Process.kill :KILL, status.pid
  end
end

assert('usage [--host]') do
  begin
    _, output, status = Open3.popen2(BINARY, '--host', '0.0.0.0')

    assert_include output.gets, 'http://0.0.0.0:'
  ensure
    Process.kill :KILL, status.pid
  end
end

assert('unknown flag') do
  _, output, status = Open3.capture3(BINARY, '-unknown')

  assert_false status.success?, 'Process did exit cleanly'
  assert_include output, 'unknown option'
end
