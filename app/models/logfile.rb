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


class Logfile
  # Initializes a job report by id and its job id.
  #
  # @return [ Orbit::Report ]
  def initialize(id, planet_id)
    @id         = id
    @planet_id  = planet_id
    @data       = get_data(id)
  end

  attr_reader :job_id, :report_id

  # The id of the planet.
  #
  # @return [ String ]
  def get_planet_id
    @planet_id
  end

  # The name of the planet.
  #
  # @return [ String ]
  def planet
    Orbit.find_planet(planet_id)['name']
  end

  # The parsed output values.
  #
  # @return [ Map ]
  def rows
    @rows ||= JSON.parse(@data['output'])
                  .map        { |r| r.delete_if(&:empty?) }
                  .keep_if    { |r| r.size == 2 }
                  .each_with_object({}) { |r, row| row[r[0]] = r[1] }
  end

  # Returns specific logfile
  #
  # @param [ String ] file_name of desired logfile
  #
  # @return [ String ]
  def get_data(file_name)
    query = "ski -c=\"cat #{Log_Config.logs_folder}#{file_name}\"  #{@planet_id}"

    output = %x[ #{query} ]
    # output, = Open3.capture3('ski', query)

    output
  end

  # Converts the report into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    {
      id:         @id,
      planet_id:  @planet_id,
      data:       get_data(@id)
    }
  end
end
