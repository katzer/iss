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

class Planet
  # Find a planet by its ID.
  #
  # @param [ String ] id The id of the planet to find for.
  #
  # @return [ Planet ] nil if not found.
  def self.find(id)
    json = fifa("-f=json #{id}", false)

    Planet.new(JSON.parse(json)) unless json.empty?
  rescue JSON::ParserError
    warn "fifa -f=json #{id} returned invalid json: #{json}"
  end

  # Scope for all planets of type server.
  #
  # @param [ String ] ids The ids of the planets to find for.
  #                       Defaults to: 'id:.*'
  #
  # @return [ Array<Hash> ]
  def self.find_all(ids = 'id:.*')
    fifa(%(-f=json "#{ids}")).each_with_object([]) do |json, planets|
      planets << new(JSON.parse(json))
    rescue JSON::ParserError
      warn "fifa -f=json #{ids} returned invalid json: #{json}"
    end
  end

  # Initializes a planet.
  #
  # @param [ Hash ] data The hash containing all information about the planet.
  #
  # @return [ Void ]
  def initialize(data)
    @data = data
    data.freeze
  end

  # The patsed JSON content returned from fifa.
  #
  # @return [ Hash<String, Object> ]
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

  # A connected SFTP session to the planet.
  #
  # @return [ SFTP::Session ]
  def sftp
    Yeah.application.settings[:pool][id]
  end

  # Proxy instance of the LFV module.
  #
  # @return [ LogFileProxy ]
  def logs
    LogFileProxy.new(id, sftp)
  end

  # Converts the object into an array struct.
  #
  # @return [ Array ]
  def to_a
    [id, @data['name'], @data['url'], @data['type']]
  end
end
