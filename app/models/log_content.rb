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

class LogContent < BasicObject
  # Initializes a log file line.
  #
  # @param [ String ]  file_id   The ID of the file.
  # @param [ String ]  planet_id The ID of the corresponding planet.
  # @param [ Integer ] pos       The line index within the file.
  # @param [ String ]  content   The content of the line.
  #
  # @return [ Void ]
  def initialize(*args)
    @args = args
  end

  # Converts the object into an array struct.
  #
  # @return [ Array ]
  def to_a
    [*@args, @ts]
  end

  protected

  # Parse the timestamp specified by the timestamp rule.
  #
  # @param [ Array ] rule         The rule howto extract the timestamp.
  # @param [ String ] ts_fallback The timestamp to use if no other can be found.
  #
  # @return [ String ] The parsed timestamp.
  def parse_ts(rule, fallback = nil)
    content = @args[3]
    @ts     = [nil, rule[5]]
    @ts[0]  = content.include?(rule[2]) ? content[rule[3], rule[4]] : fallback
  end
end
