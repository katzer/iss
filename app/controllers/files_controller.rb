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

class FilesController < # noinspection RubyResolve,RubyResolve
Yeah::Controller
  # Render a list of all planets of type server.
  #
  # @return [ Void ]
  def planets
    planets = Planet.servers
    planets ? render(json: planets) : render(400)
  end

  # Render a list of all log files.
  #
  # @param [ String ] planet_id The ID of the planet where to look for.
  #
  # @return [ Void ]
  def files(planet_id)
    error_code = validate_request(planet_id)
    if error_code != 0
      render(error_code)
      return
    end
    planet = Planet.find(planet_id)
    planet ? logfiles = planet.logfiles : render(404)
    logfiles ? render(json: logfiles) : render(404)
  end

  # Render the content of a log file.
  #
  # @param [ String ] planet_id The ID of the planet where to look for.
  # file_id: The id or path of the file to render.
  #
  # @return [ Void ]
  def file(planet_id)
    file_id = params['file_id']
    error_code = validate_request(planet_id, file_id)
    if error_code != 0
      render(error_code)
      return
    end
    planet = Planet.find(planet_id)
    logfile = planet.logfile(file_id) if planet
    logfile ? render(json: logfile.lines) : render(404)
  end

  #
  #
  #
  def validate_request(planet_id, file_id = nil)
    return 404 unless Planet.exist?(planet_id)
    return 403 unless Planet.valid?(planet_id)
    return 0 if file_id.nil?
    return 400 if Logfile.bad_request?(file_id)
    0
  end
end