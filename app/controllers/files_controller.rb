# Apache 2.0 License
#
# Copyright (c) Copyright 2016 Sebastian Katzer, appPlant GmbH
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

class FilesController < Yeah::Controller
  # Render a list of all planets of type server.
  #
  # @return [ Void ]
  def planets
    planets = Planet.find_all(ISS::Fifa.lfv)
    planets ? render(json: planets.map(&:to_h)) : render(404)
  end

  # Render a list of all log files.
  #
  # @param [ String ] planet_id The ID of the planet where to look for.
  #
  # @return [ Void ]
  def files(planet_id)
    code = validate_request(planet_id)

    return render(code) unless code == 0

    planet = Planet.find(planet_id)

    return render(404) unless planet

    render json: planet.logfiles.find_all.map(&:to_h)
  end

  # Render the content of a log file.
  #
  # @param [ String ] planet_id The ID of the planet where to look for.
  # @param [ String ] file_id   The id or path of the file to render.
  #
  # @return [ Void ]
  def file(planet_id)
    file_id = params['file_id']&.gsub('%2F', '/')
    code    = validate_request(planet_id, file_id)

    return render(code) unless code == 0

    file = Planet.find(planet_id)&.logfiles&.find(file_id)

    file ? render(json: file.lines) : render(404)
  end

  private

  # Validate if planet and file specified by id are allowed to access.
  #
  # @param [ String ] planet_id The ID of the planet.
  # @param [ String ] file_id   The ID of the file.
  #
  # @return [ Number ] HTTP Status Code
  def validate_request(planet_id, file_id = nil)
    return 404 unless ISS::LFV.include? planet_id
    return 0   unless file_id
    return 400 unless Logfile.valid?(file_id)
    return 404 unless ISS::LFV.new(planet_id).include? file_id
    0
  end
end
