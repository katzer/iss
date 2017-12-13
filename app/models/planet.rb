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
