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

module Kernel
  # Yields obj and returns the result.
  #
  # @return [ Object ]
  def yield_self(&block)
    block.call(self)
  end

  # The settings hash for this yeah app.
  #
  # @return [ Hash ]
  def settings
    Yeah.application.settings
  end

  # Invoke fifa with the specified query string.
  #
  # @param [ String ] query  The query to ask for.
  # @param [ Boolean ] split Set to true to autmatically split the output.
  #                          Defaults to: true
  #
  # @return [ Array<String> ]
  def fifa(query, split = true)
    bin = ENV.include?('ORBIT_BIN') ? "#{ENV['ORBIT_BIN']}/fifa" : 'fifa'
    cmd = "#{bin} -n #{query}"
    out = `#{cmd}`

    raise "#{cmd} failed with exit code #{$?}" unless $? == 0

    split ? out.split("\n") : out
  end

  # Displays the given message on STDERR.
  #
  # @param [ String ] msg The error message.
  #
  # @return [ Void ]
  def warn(msg)
    STDERR.puts msg
  end
end
