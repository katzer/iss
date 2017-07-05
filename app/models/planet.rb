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
    query = "fifa"
    LFV_CONFIG["planets"].each do |param|
      query << " " << param
    end
    planets = %x[ #{query} ]
    planets.split("\n")
  end

  # Checks, if a planet is valid.
  #
  # @return [ Boolean ]
  def self.valid?(planet_id)
    Planet.servers.include?(%x[ fifa #{planet_id} ].chomp!)
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
    %x[ fifa ].split("\n").include?(%x[ fifa #{planet_id} ].chomp!)
  end


  # Private Initializer for a planet by id.
  #
  # @param [ String ] id The planet id.
  #
  # @return [ Planet ]
  def initialize(id)
    @id = id.to_s
    @logfiles = init_logfiles
  end

  attr_reader :id

  # List of reports associated to the planet.
  #
  # @return [ Array<Hash> ]
  def init_logfiles
    # command = %q{. ~/profiles/`whoami`.prof}
    command = ". ~/profiles/`whoami`.prof"
    LFV_CONFIG["files"].each do |cmd|
      command << " && find " << cmd
    end
    query = "ski -c='#{command}' #{@id}"
    output = %x[ #{query} ]

    h = Hash.new
    split_list = output.split("\n")
    split_list.map{ |f|
      tokens = f.split("/")
      h[f] = tokens[tokens.length-1]}
    h
  end

  # Returns specified logfile
  #
  # @return [ Logfile ]
  def logfile(file_name)
    i = 0
    query = "ski -c=\"cat #{file_name}\"  #{@id}"

    output = %x[ #{query} ]
    split_list = output.split("\n")
    Logfile.new(file_name, @id, split_list)

  end

  # Returns the list of logfiles on the specified planet as a array of hashes.
  #
  # @return [ Array<Hash> ]
  def logfiles
    ary = Array.new
    @logfiles.each do |key,value|
      ary.push({
        id:         key,
        planet_id:  @id,
        name:       value
      })
    end
    ary
  end

end
