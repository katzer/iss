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

class StatsController < Yeah::Controller
  # Default result set for the stats action
  STATS = [
    { id: 'server', name: 'Instances' }.freeze,
    { id: 'db',     name: 'Databases' }.freeze,
    { id: 'web',    name: 'Webserver' }.freeze,
    { id: 'tool',   name: 'Tools'     }.freeze
  ].freeze

  # Render stats about how many planets of each type are defined.
  #
  # @return [ Void ]
  def stats
    stats, ok = fifa tail: '-c type=server type=db type=web type=tool'

    return render(500) unless ok

    render(json: STATS.zip(stats).map! { |s, c = 0| s.merge count: c.to_i })
  end

  # Render count of planets who have the specified type.
  #
  # @param [ String ] type The name of the type to search for.
  #
  # @return [ Void ]
  def count(type)
    count, ok = fifa "-c type=#{type}"

    return render(500) unless ok

    render(json: count[0].to_i)
  end

  # Render list of ids who have the specified type.
  #
  # @param [ String ] type The name of the type to search for.
  #
  # @return [ Void ]
  def list(type)
    ids, ok = fifa "type=#{type}"

    return render(500) unless ok

    render(json: ids)
  end

  private

  # Invoke fifa with the specified query string.
  #
  # @param [ String ] query The query to ask for.
  #
  # @return [ Array<String, Boolean> ]
  def fifa(query)
    ISS::Fifa.call(query)
  end
end
