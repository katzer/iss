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
  # Scope for all planets of type server
  #
  # @return [ Array<Hash> ]
  def self.servers
    planets = fifa_planets
    to_return = []
    planets.each do |param|
      planet = param.split('|')
      to_add = { id: planet[1], name: planet[3], address: planet[4] }
      to_return << to_add
    end
    to_return
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

  # Checks, if a planet is valid.
  #
  # @return [ Boolean ]
  def self.valid?(planet_id)
    Planet.servers.each do |planet|
      return true if planet[:id].include?(planet_id)
      return true if planet[:name].include?(planet_id)
    end
    false
  end

  # Find planet by id.
  #
  # @param [ String ] id The planet id.
  #
  # @return [ Planet ]
  def self.find(id)
    new(id) if exist? id
  end

  # Check if a planet exists.
  #
  # @param [ String ] id The planet id to check for.
  #
  # @return [ Boolean ]
  def self.exist?(planet_id)
    LFV_CONFIG['planets'].include? planet_id
  end

  # Private Initializer for a planet by id.
  #
  # @param [ String ] id The planet id.
  #
  # @return [ Planet ]
  def initialize(id)
    query = "fifa -f=ski #{id}"
    fifa_string = `#{query}`

    return nil unless $? == 0
    planet = fifa_string.split("\n")[0].split('|')
    @id = id.to_s
    @name = planet[3]
    @address = planet[4]
  end

  attr_reader :id, :name, :address

  # List of reports associated to the planet.
  #
  # @return [ Array<Hash> ]
  def logfiles
    raw_list = raw_logfile_list
    a = []
    raw_list.map { |f|
      tokens = f.split('/')
      entry = { id: f, name: tokens[tokens.length - 1], planet_id: @id }
      a << entry
    }
    a
  end

  def raw_logfile_list
    command = '. ~/profiles/`whoami`.prof'
    LFV_CONFIG['files'].each do |cmd|
      command << ' && find ' << cmd
    end
    query = "ski -c='#{command}' #{@id}"
    output = `#{query}`
    return nil unless $? == 0
    output.split("\n")
  end

  # Returns specified logfile
  #
  # @return [ Logfile ]
  def logfile(file_name)
    query = "ski -c=\"cat #{file_name}\"  #{@id}"

    output = `#{query}`

    return nil unless $?. == 0

    split_list = output.split("\n")
    Logfile.new(file_name, @id, split_list)
  end

  # Converts the planet into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    {
      id: @id,
      name: @name,
      address: @address
    }
  end
end
