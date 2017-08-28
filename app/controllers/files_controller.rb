#
# Copyright (c) 2016 by appPlant GmbH. All rights reserved.
#
# @APPPLANT_LICENSE_HEADER_START@
#
# This file contains Original Code and/or Modifications of Original Code
# as defined in and that are subject to the Apache License
# Version 2.0 (the 'License'). You may not use this file except in
# compliance with the License. Please obtain a copy of the License at
# http://opensource.org/licenses/Apache-2.0/ and read it before using this
# file.
#
# The Original Code and all software distributed under the License are
# distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
# EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
# INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
# Please see the License for the specific language governing rights and
# limitations under the License.
#
# @APPPLANT_LICENSE_HEADER_END@

class FilesController < Yeah::Controller # noinspection RubyResolve,RubyResolve
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
