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

class StatsController < ApplicationController
  # Default result set for the stats action
  STATS = [
    %w[server Instances].freeze,
    %w[db Databases].freeze,
    %w[web Webserver].freeze,
    %w[tool Tools].freeze
  ].freeze

  # Render stats about how many planets of each type are defined.
  #
  # @return [ Void ]
  def index
    stats = fifa('-c type=server type=db type=web type=tool')

    render(json: STATS.zip(stats).map! { |s, c = 0| s.dup << c.to_i })
  end

  # Render count of planets who have the specified type.
  #
  # @param [ String ] type The name of the type to search for.
  #
  # @return [ Void ]
  def count(type)
    render json: fifa("-c type=#{type}")[0].to_i
  end

  # Render list of ids who have the specified type.
  #
  # @param [ String ] type The name of the type to search for.
  #
  # @return [ Void ]
  def list(type)
    render json: fifa("type=#{type}")
  end
end
