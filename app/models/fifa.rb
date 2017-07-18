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

class Fifa
  # Scope for all planets of type server
  #
  # @return [ Array<Hash> ]
  def self.planets_raw
    planets = fifa_planets
    planets.map do |param|
      _, id, type, name, = param.split('|')
      { id: id, name: name, type: type }
    end
  end

  # Calls fifa to get the connection details to each viable planet
  #
  # @return [ Array<String> ]
  def self.fifa_planets
    query = 'fifa -f=ski'
    LFV_CONFIG['planets'].each do |param|
      query << ' ' << param
    end
    fifa_string = `#{query}`
    fifa_string.split("\n")
  end

  # Private Initializer for a planet by id.
  #
  # @param [ String ] id The planet id.
  #
  # @return [ Planet ]
  def self.planet_raw(id)
    query = "fifa -f=ski #{id}"
    fifa_string = `#{query}`

    return nil unless $? == 0 # rubocop:disable Style/NumericPredicate
    planet = fifa_string.split("\n")[0].split('|')
    return id.to_s, planet[3], planet[2]
  end
end