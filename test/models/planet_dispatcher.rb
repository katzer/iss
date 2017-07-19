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

assert 'test servers' do
  planet_dispatcher = PlanetDispatcher.new
  fifa = planet_dispatcher.instance_variable_get(:@fifa)
  def fifa.planets_raw
    fixture('servers').split("\n")
  end

  planet = planet_dispatcher.servers[0]

  assert_equal planet.name, 'localhost'
  assert_equal planet.id,   'localhost'
  assert_equal planet.type, 'server'
end

assert 'test servers_for_lfv' do
  planet_dispatcher = PlanetDispatcher.new
  fifa = planet_dispatcher.instance_variable_get(:@fifa)
  def fifa.lfv_planets_raw
    fixture('servers').split("\n")
  end

  planet = planet_dispatcher.servers_for_lfv[0]

  assert_equal planet.name, 'localhost'
  assert_equal planet.id,   'localhost'
  assert_equal planet.type, 'server'
end

assert 'test valid?' do
  planet_dispatcher = PlanetDispatcher.new
  fifa = planet_dispatcher.instance_variable_get(:@fifa)
  def fifa.lfv_planets_raw
    fixture('servers').split("\n")
  end

  valid = planet_dispatcher.valid? 'localhost'

  assert_equal valid, true
end

assert 'test find' do
  planet_dispatcher = PlanetDispatcher.new
  fifa = planet_dispatcher.instance_variable_get(:@fifa)
  def fifa.lfv_planets_raw
    fixture('servers').split("\n")
  end

  def fifa.planet(id)
    Planet.new(id, 'localhost', 'server')
  end

  planet = planet_dispatcher.find('localhost')

  assert_equal planet.name, 'localhost'
  assert_equal planet.id,   'localhost'
  assert_equal planet.type, 'server'
end
