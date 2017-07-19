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
  fifa = Fifa.new
  def fifa.planets_raw
    fixture('servers').split
  end
  planet = fifa.servers[0]

  assert_equal planet, id: 'localhost', name: 'localhost', type: 'server'
end

assert 'test servers_for_lfv' do
  fifa = Fifa.new
  def fifa.lfv_planets_raw
    fixture('servers').split
  end
  planet = fifa.servers_for_lfv[0]

  assert_equal planet, id: 'localhost', name: 'localhost', type: 'server'
end

assert 'test planets_raw' do
  fifa = Fifa.new
  def fifa.call(_)
    fixture('servers')
  end
  planet = fifa.planets_raw[0]

  assert_equal planet, '1|localhost|server|localhost|mrblati@localhost'
end

assert 'test lfv_planets_raw' do
  fifa = Fifa.new
  def fifa.call(_)
    fixture('servers')
  end
  planet = fifa.lfv_planets_raw[0]

  assert_equal planet, '1|localhost|server|localhost|mrblati@localhost'
end

assert 'test planet' do
  fifa = Fifa.new
  def fifa.call(_)
    fixture('planet')
  end
  planet = fifa.planet('localhost')

  assert_equal planet.id,   'localhost'
  assert_equal planet.name, 'localhost'
  assert_equal planet.type, 'server'
end







