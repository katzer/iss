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
  # Reads the iss.json config file
  class Config
    # Parse the iss.json config file.
    #
    # @param [ String ] path The path to the config file.
    #                        Defaults to: 'config/iss.json'
    #
    # @return [ Hash ]
    def self.parse(path = 'config/iss.json')
      new(path).to_h
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

    # Converts the config into a hash.
    #
    # @return [ Hash ]
    def to_h
      @cfg
    end

    private

    # Parse the config file.
    #
    # @return [ Hash<Symbol,Object> ]
    def parse
      cfg = load_config

      cfg[:planets] = parse_planets(cfg[:planets])
      cfg[:files].map! { |f| parse_file(f) }
      cfg[:encodings].transform_values!(&:to_sym)
      cfg[:'cache-controls'].transform_keys!(&:to_sym)
      cfg[:groups].each { |k, v| v.replace(planets: parse_planets(v['planets']), files: parse_files(v['files'])) }

      cfg
    end

    def load_config
      cfg = JSON
        .parse(IO.read("#{ENV['ORBIT_HOME']}/#{@path}"))
        .transform_keys!(&:to_sym)

      cfg[:files] ||= []
      cfg[:encodings] ||= {}
      cfg[:'cache-controls'] ||= {}
      cfg[:groups] ||= []
      cfg[:timestamps] ||= []
      cfg[:filters] ||= []

      cfg
    end

    def parse_planets(planets)
      [planets].flatten.join(' ')
    end

    def parse_file(file)
      file.is_a?(Array) ? file : [file, 0]
    end

    def parse_files(files)
      files&.map! { |f| parse_file(f) } || []
    end
  end
end
