# Apache 2.0 License
#
# Copyright (c) 2022 Sebastian Katzer
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

module FindPlanet

  # Find all planets that matches the given matcher.
  #
  # @param [ String ] planet_id The id of the planet.
  #
  # @raise [ PlanetNotFound ]
  #
  # @return [ Planet ]
  def self.by_id(planet_id, scope: nil)
    if planet_id == Galaxy::MILKY_WAY_ID
      Galaxy.milky_way
    else
      Planet.find(query(planet_id))
    end.to_h
  end

  private

  def self.query(planet_id)
    settings[:planets].split
                      .map! { |it| it.gsub('"', '') }
                      .map! { |it| "#{it}@id=#{planet_id}" }
                      .join(' ')
  end
end
