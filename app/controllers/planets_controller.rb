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

class PlanetsController < Yeah::Controller
  # Render a list of planets that matches the scope.
  #
  # @param [ String ] scope The scope (lfv, server, etc.)
  #
  # @return [ Void ]
  def index
    render json: Planet.find_all(scope).map!(&:to_a)
  end

  # Render the data of a planet.
  #
  # @param [ String ] id The ID of the planet.
  #
  # @return [ Void ]
  def show(id)
    planet = Planet.find("id=#{id}")

    planet ? render(json: planet.data) : render(404)
  end

  private

  # The pattern to match the specified scope.
  #
  # @return [ String ]
  def scope
    case params['scope']
    when 'lfv'                 then Yeah.application.settings[:lfv][:planets]
    when 'server', 'db', 'web' then "type=#{params['scope']}"
    when nil                   then 'id:.*'
    else raise 'Unknown scope'
    end
  end
end
