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

class Result
  # Initializes a job report by id and its job id.
  #
  # @return [ Report ]
  def initialize(job_id, report_id, data)
    @job_id    = job_id
    @report_id = report_id
    @data      = data
  end

  attr_reader :job_id, :report_id

  # The id of the planet.
  #
  # @return [ String ]
  def planet_id
    @data['id']
  end

  # The name of the planet.
  #
  # @return [ String ]
  def planet
    Planet.find(planet_id).name
  rescue StandardError => _
    planet_id
  end

  # The parsed output values.
  #
  # @return [ Map ]
  def rows
    @data[:output].to_h
  end

  # Converts the object into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    {
      job_id:    job_id,
      report_id: report_id,
      planet_id: planet_id,
      valid:     !@data['errored'],
      planet:    planet
    }.merge!(rows)
  end
end
