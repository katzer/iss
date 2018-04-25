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

class Logfile
  # If the file_id goes along with the rules for file id syntax.
  #
  # @param [ String ] file_id The ID of the file to check for.
  #
  # @return [ Boolean ]
  def self.valid?(file_id)
    %w[& " ' \\ \ ].none? { |token| file_id.include? token }
  end

  # Initializes a log file.
  #
  # @param [ String ] id        The Id (e.g. path) of the file.
  # @param [ String ] planet_id The ID of the planet where the file is located.
  # @param [ String ] plc_id    Optional PLC identifier (AKZ).
  #
  # @return [ Void ]
  def initialize(id, planet_id, plc_id = nil)
    @id         = id
    @name       = plc_id ? "#{id} [#{plc_id}]" : id
    @planet_id  = planet_id
  end

  attr_reader :id, :name, :planet_id

  # If the id of the file goes along with the rules for file id syntax.
  #
  # @return [ Boolean ]
  def valid?
    self.class.valid? id
  end

  # Returns the contents of a logfile as a Hash-Array
  #
  # @return [ Array<Hash> ]
  def lines
    lines              = []
    output, successful = ISS::Ski.logfile(id).call(tail: planet_id)

    return lines unless successful

    output.each_with_index do |l, i|
      lines << { file_id: id, planet_id: planet_id, line: i + 1, content: l }
    end

    lines
  end

  # Converts the object into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    { id: id, planet_id: planet_id, name: name }
  end
end
