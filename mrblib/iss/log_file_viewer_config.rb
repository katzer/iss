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
  # Reads the lfv.json config file
  class LogFileViewerConfig
    # Parse the lfv.json config file.
    #
    # @param [ String ] path The path to the config file.
    #                        Defaults to: 'config/lfv.json'
    #
    # @return [ ISS::LogFileViewerConfig ]
    def self.parse(path = 'config/lfv.json')
      new(path)
    end

    # Initialize a new config object.
    #
    # @param [ String ] path The path to the config file.
    #
    # @return [ Void ]
    def initialize(path)
      @path = path
      @cfg  = parse
    end

    # Return a config value.
    #
    # @param [ Symbol ] key The config key.
    #
    # @return [ Object ]
    def [](key)
      @cfg[key]
    end

    # Extracts the nested value specified by the sequence of keys
    #
    # @param [ *Object ] keys A sequence of keys.
    #
    # @return [ Object]
    def dig(*keys)
      @cfg.dig(*keys)
    end

    # Reload the config file.
    #
    # @return [ Void ]
    def reload
      @cfg.replace(parse)
    end

    private

    # Parse the config file.
    #
    # @return [ Hash<Symbol,Object> ]
    def parse
      planets, files, encodings, timestamps, filters, cache_controls =
        JSON.parse(IO.read("#{ENV['ORBIT_HOME']}/#{@path}"))
            .values_at('planets', 'files', 'encodings',
                       'timestamps', 'filters', 'cache-controls')

      {
        planets: [planets].flatten.join(' '),
        files: files&.map! { |f| f.is_a?(Array) ? f : [f, 0] },
        encodings: encodings&.transform_values!(&:to_sym),
        timestamps: timestamps,
        filters: filters,
        'cache-controls': cache_controls&.transform_keys!(&:to_sym)
      }
    end
  end
end
