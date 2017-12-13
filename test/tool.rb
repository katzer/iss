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
