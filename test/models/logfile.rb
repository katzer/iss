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

def fixture(file)
  File.read File.join(File.dirname(__FILE__), "../fixtures/#{file}")
end

assert 'test init' do
  id = '/home/mrblati/workspace/orbit/config/orbit.json'
  logfile = Logfile.new(id, 'localhost', 'orbit.json')

  assert_equal logfile.id,        id
  assert_equal logfile.planet_id, 'localhost'
  assert_equal logfile.name,      'orbit.json'
end

assert 'test planet' do
  id = '/home/mrblati/workspace/orbit/config/orbit.json'
  logfile = Logfile.new(id, 'localhost', 'orbit.json')
  planet = logfile.planet
  assert_equal planet, 'localhost'
end

assert 'test lines' do
  id = '/home/mrblati/workspace/orbit/config/orbit.json'
  logfile = Logfile.new(id, 'localhost', 'orbit.json')
  ski = logfile.instance_variable_get(:@ski)
  def ski.logfile(_, _)
    fixture('logfile').split("\n")
  end

  lines = logfile.lines
  line_zero = lines[0]

  assert_equal line_zero[:file_id],   id
  assert_equal line_zero[:planet_id], 'localhost'
  assert_equal line_zero[:line],      '0'
  assert_equal line_zero[:content],   'this'
end

assert 'test to_h' do
  id = '/home/mrblati/workspace/orbit/config/orbit.json'
  logfile = Logfile.new(id, 'localhost', 'orbit.json').to_h

  assert_equal logfile, id: id, planet_id: 'localhost', name: 'orbit.json'
end
