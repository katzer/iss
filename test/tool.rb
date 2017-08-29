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

class ISS::Tool
  def exec(cmd)
    cmd
  end
end

class TestTool1 < ISS::Tool
  self.bin = 'testtool1'
end

class TestTool2 < ISS::Tool
  self.bin = 'testtool2'
  self.path = '/path/to'
end

class TestTool3 < ISS::Tool
  self.bin  = 'testtool3'
  self.path = '/path/to'
  self.args = '-arg=0'
end

class TestTool4 < ISS::Tool
  self.bin  = 'fifa'
  scope :servers, -> { 'type=server' }
end

assert 'ISS::Tool.bin' do
  assert_equal 'testtool1', TestTool1.bin
  assert_equal TestTool1.new.bin, TestTool1.bin
end

assert 'ISS::Tool.args' do
  assert_equal '-arg=0', TestTool3.args
  assert_equal TestTool3.new.args, TestTool3.args
end

assert 'ISS::Tool.path' do
  assert_equal '/path/to', TestTool2.path
  assert_equal '/path/to/testtool2', TestTool2.new.path
  assert_equal 'testtool1', TestTool1.new.path
end

assert 'ISS::Tool.command' do
  tool = TestTool3.new

  assert_equal '/path/to/testtool3 -arg=0', tool.command
  assert_equal '/path/to/testtool3 -arg=0', tool.command('-arg=1')
  assert_equal '/path/to/testtool3 -opt=1 -arg=0', tool.command('-opt=1')
  assert_equal '/path/to/testtool3 -h -arg=0', tool.command(args: '-h')
  assert_equal '/path/to/testtool3 -arg=0 "a b"', tool.command(tail: '"a b"')
end

assert 'ISS::Tool#new' do
  tool = TestTool1.new('-f=ski')

  assert_equal 'testtool1 -f=ski', tool.command
  assert_equal 'testtool1 -h -f=ski', tool.command('-h')

  tool = TestTool1.new(args: '-f=ski', tail: '"a b"')

  assert_equal 'testtool1 -f=ski "a b"', tool.command
  assert_equal 'testtool1 -f=ski "a b" c', tool.command(tail: 'c')
end

assert 'ISS::Tool#scope' do
  assert_equal 'fifa type=server', TestTool4.servers.command
end

assert 'ISS::Tool.call' do
  tool = TestTool4.servers

  assert_equal 'fifa type=server', tool.call
end

assert 'ISS::Tool#call' do
  tool = TestTool1.new

  assert_equal 'testtool1', tool.call
  assert_equal tool.class.call, tool.call
end
