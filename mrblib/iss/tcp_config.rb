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
  # Wrapper around a tcp_config file
  class TCPConfig < BasicObject
    TCP       = 'TCP'.freeze
    TCP_TRACE = '/tcp_trace.'.freeze

    # Initialize a tcp_config instance by passing its remote content.
    #
    # @param [ String ] content The content of the file.
    #
    # @return [ Void ]
    def initialize(content)
      @plc_ids = parse(content.split("\n"))
    end

    private

    # Parse the lines of the file to find all PLC identifiers.
    #
    # @param [ Array<String> ] lines The lines of the file.
    #
    # @return [ Hash<String,String> ] Mapping of node:plc pairs
    def parse(lines)
      prev = ''

      lines.each_with_object({}) do |line, map|
        (prev = line) && next if line[0, 3] != TCP

        id  = line.split[1]
        akz = prev.split(';')[0]&.sub('#', '')&.strip

        map[id] = akz unless akz && akz.length > 8
      end
    end

    # Returns the PLC identifier for the tcp_trace file.
    #
    # @param [ String ] path The path of the tcp_trace file.
    #
    # @return [ String ]
    def [](path)
      @plc_ids[path.split(TCP_TRACE)[1]&.split('.')&.first]
    end
  end
end
