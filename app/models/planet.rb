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
  def servers
    query = "fifa"
    CONFIG_FILE[planets].each do |param|
      query << " " << param
    end
    planets = %x[ #{query} ]
    planets.split("\n").map! { |planet| planet.chomp!}
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
  def self.exist?(id)
    planet = ORBIT_FILE.find { |planet| planet['id'] == id }
    planet ? true : false
  end


  # Private Initializer for a planet by id.
  #
  # @param [ String ] id The planet id.
  #
  # @return [ Planet ]
  def initialize(id)
    @id = id.to_s
  end

  attr_reader :id

  # List of reports associated to the planet.
  #
  # @return [ Logfile_List ]
  def logfile_list
    command = ""
    first = true
    CONFIG_FILE["files"].each do |cmd|
      command << " && " unless first
      command << "find " << cmd
      first = false
    end
    query = "ski -c=\"#{command}\" #{@id}"


    output = %x[ #{query} ]
    # output, = Open3.capture3('ski', query)

    split_list = output.split("\n")
    split_list.map!{ |f|
      tokens = f.split("/")
      f = Logfile_List.new(f , @id, tokens[tokens.length-1]) }
  end

  # Returns specified logfile
  #
  # @return [ Logfile ]
  def logfile(file_name)
    i = 0
    query = "ski -c=\"cat #{file_name}\"  #{@planet_id}"

    output = %x[ #{query} ]
    split_list = output.split("\n")
    split_list.map!{ |f|
      f = Logfile.new(file_name, @id, i, f)
      i += 1
      f
      # TODO schöner?
    }
    # output, = Open3.capture3('ski', query)

  end

end
