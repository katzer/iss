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

class Planet
  # Find a planet by its ID.
  #
  # @param [ String ] id The id of the planet to find for.
  #
  # @return [ Planet ] nil if not found.
  def self.find(id)
    items, successful = ISS::Fifa.call(tail: id)

    return nil unless items.any? && successful

    Planet.new(JSON.parse(items[0]))
  end

  # Scope for all planets of type server
  #
  # @return [ Array<Hash> ]
  def self.find_all(scope = ISS::Fifa)
    items, successful = scope.call

    return [] unless successful

    items.map! { |json| new JSON.parse(json) }
  end

  # Initializes a planet.
  #
  # @param [ Hash ] data The hash containing all information about the planet.
  #
  # @return [ Void ]
  def initialize(data)
    @data = data
  end

  attr_reader :data

  # Hash-like access to all properties.
  #
  # @param [ String ] The name of the property.
  #
  # @return [ Object ] The value.
  def [](key)
    @data[key]
  end

  # The id of the planet.
  #
  # @return [ String ]
  def id
    @data['id']
  end

  # The name of the planet.
  #
  # @return [ String ]
  def name
    @data['name']
  end

  # The type of the planet.
  #
  # @return [ String ]
  def type
    @data['type']
  end

  # Proxy instance of the LFV module.
  #
  # @return [ ISS::LFV ]
  def logfiles
    ISS::LFV.new(id)
  end

  # Converts the object into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    { id: id, name: name, type: type }
  end
end
