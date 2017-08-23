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

assert 'test find' do
  planet = Planet.find('localhost')

  assert_equal planet.id,   'localhost'
  assert_equal planet.name, 'localhost'
  assert_equal planet.type, 'server'
end

module ISS
  # Override for fifa
  class Fifa
    def exec(_)
      [fixture('servers').split("\n"), 0]
    end
  end
end

assert 'test servers' do
  planet = Planet.servers[0]

  assert_equal planet.id,   'localhost'
  assert_equal planet.name, 'localhost'
  assert_equal planet.type, 'server'
end

assert 'test servers_for_lfv' do
  planet = Planet.servers_for_lfv[0]

  assert_equal planet.id,   'localhost'
  assert_equal planet.name, 'localhost'
  assert_equal planet.type, 'server'
end

assert 'test init' do
  planet = Planet.new('id' => 'localhost',
                      'name' => 'localhost', 'type' => 'server')

  assert_equal planet.id,   'localhost'
  assert_equal planet.name, 'localhost'
  assert_equal planet.type, 'server'
end

assert 'test logfile' do
  id = '/home/mrblati/workspace/orbit/config/orbit.json'
  planet = Planet.new('id' => 'localhost',
                      'name' => 'localhost', 'type' => 'server')

  logfile = planet.logfile('/home/mrblati/workspace/orbit/config/orbit.json')

  assert_equal logfile.id,        id
  assert_equal logfile.planet_id, 'localhost'
  assert_equal logfile.name,      'orbit.json'
end

assert 'test to_h' do
  planet = Planet.new('id' => 'localhost',
                      'name' => 'localhost', 'type' => 'server')

  assert_equal(planet.to_h, id: 'localhost', name: 'localhost', type: 'server')
end

module ISS
  # Override for fifa
  class Ski
    def exec(_)
      [fixture('logfile_list').split("\n"), 0]
    end
  end
end

assert 'test logfiles' do
  planet = Planet.new('id' => 'localhost',
                      'name' => 'localhost', 'type' => 'server')
  id = '/home/mrblati/workspace/orbit/config/orbit.json'

  logfiles = planet.logfiles
  logfile = logfiles[0]

  assert_equal logfile.id,        id
  assert_equal logfile.planet_id, 'localhost'
  assert_equal logfile.name,      'orbit.json'
end
