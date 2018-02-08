# Apache 2.0 License
#
# Copyright (c) 2016 Sebastian Katzer, appPlant GmbH
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

    # The parsed JSON config file.
    #
    # @return [ Hash ]
    def self.config
      @config ||= begin
        JSON.parse(IO.read(File.join(ENV['ORBIT_HOME'], 'config/lfv.json')))
      end
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
