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

class Fifa < Executor
  # Scope for all planets of type server
  #
  # @return [ Array<Planet> ]
  def servers
    planets_raw.map do |param|
      _, id, type, name, = param.split('|')
      { id: id, name: name, type: type }
    end
  end

  # Scope for all planets of type server
  #
  # @return [ Array<Planet> ]
  def servers_for_lfv
    lfv_planets.map do |param|
      _, id, type, name, = param.split('|')
      { id: id, name: name, type: type }
    end
  end

  # Scope for all planets of type server
  #
  # @return [ Array<Hash> ]
  def planets_raw
    planets = call(cmd: 'fifa -f=ski type=server')
    planets.split("\n")
  end

  def planet(id)
    raw = call(cmd: "fifa -f=ski #{id}").chomp!
    _, id, type, name, = raw.split('|')
    Planet.new(id, name, type)
  end

  # Calls fifa to get the connection details to each viable planet
  #
  # @return [ Array<String> ]
  def lfv_planets
    planets = ''
    LFV_CONFIG['planets'].map { |p| planets << " #{p}" }
    planet_list = call(cmd: "fifa -f=ski #{planets}") # TODO: merge gibts ansch ned und split funktioniert in der ooo nich
    planet_list.split("\n")
  end
end
