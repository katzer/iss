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

module ISS
  # Proxy class for the log file viewer module.
  class LFV
    # Find all configured planets by ID.
    #
    # @return [ Array<String> ]
    def self.planet_ids
      ids, successful = ISS::Fifa.lfv.call('-a=id')

      successful ? ids : []
    end

    # If the module is available for the specified planet.
    #
    # @param [ String ] planet_id The ID of the planet to check for.
    #
    # @return [ Boolean ]
    def self.include?(planet_id)
      planet_ids.include? planet_id
    end

    # Initializes a LFV instance for the specified planet.
    #
    # @param [ String ] planet_id  The ID of the planet.
    # @param [ Boolean] skip_check Set to true to skip check if module is
    #                              available for the specified planet.
    #
    # @return [ Void ]
    def initialize(planet_id)
      @planet_id = planet_id
    end

    attr_reader :planet_id

    # If the module is available for the planet.
    #
    # @return [ Boolean ]
    def valid?
      self.class.include?(planet_id)
    end

    # Test if the given file_id can be found on the server.
    #
    # @param [ String ] file_id The id of the file to check for.
    #
    # @return [ Boolean ]
    def include?(file_id)
      file_ids.include? file_id
    end

    # List of all found file ids on the planet.
    #
    # @return [ Array<String> ]
    def file_ids
      return [] unless valid?

      ids, successful = ISS::Ski.logfiles.call(tail: planet_id)

      successful ? ids : []
    end

    alias find_ids file_ids

    # List of all log files found on the planet.
    #
    # @return [ Array<Logfile> ]
    def files
      file_ids.map! { |id| Logfile.new(id, planet_id) }
    end

    alias find_all files

    # Find the logfile by ID.
    #
    # @param [ String ] id The id of the file to find for.
    #
    # @return [ Logfile ]
    def find(file_id)
      return nil unless valid?
      Logfile.new(file_id, planet_id) if include? file_id
    end
  end
end
