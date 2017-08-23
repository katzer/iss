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
  # Private Initializer for a planet by id.
  #
  # @param [ Hash ] h The hash containing all information about the planet.
  #
  # @return [ Planet ]
  def initialize(h)
    @data = h
  end

  attr_reader :data

  # def [](key)
  #   @data[key]
  # end

  def id
    @data['id']
  end

  def name
    @data['name']
  end

  def type
    @data['type']
  end

  def self.find(id)
    json = JSON.parse(ISS::Fifa.new.call(tail: id)[0][0])
    Planet.new(json)
  end

  # Scope for all planets of type server
  #
  # @return [ Array<Hash> ]
  def self.servers
    raw = ISS::Fifa.servers.call
    Planet.parse_planets(raw)
  end

  # Scope for all planets of type server
  #
  # @return [ Array<Hash> ]
  def self.servers_for_lfv
    raw = ISS::Fifa.lfv.call
    Planet.parse_planets(raw)
  end

  def self.parse_planets(planet_list)
    return nil if planet_list[1] != 0
    planet_list[0].map do |param|
      Planet.new(JSON.parse(param))
    end
  end

  # Checks, if a planet is valid.
  #
  # @return [ Boolean ]
  def self.valid?(planet_id)
    Planet.servers_for_lfv.any? { |p| p.data['id'] == planet_id }
  end

  # List of reports associated to the planet.
  #
  # @return [ Array<Hash> ]
  def logfiles
    ISS::Ski.new.raw_logfile_list(@data['id']).map do |f|
      tokens = f.split('/')
      Logfile.new(f, @data['id'], tokens[tokens.length - 1])
    end
  end

  # Returns specified logfile
  #
  # @return [ Logfile ]
  def logfile(file_name)
    tokens = file_name.split('/')
    Logfile.new(file_name, @data['id'], tokens[tokens.length - 1])
  end

  # Converts the planet into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    {
      id:   @data['id'],
      name: @data['name'],
      type: @data['type']
    }
  end
end
