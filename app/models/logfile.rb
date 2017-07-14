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
  def initialize(id, planet_id, content)
    @id         = id
    @planet_id  = planet_id
    @lines      = lines_init(content)
  end

  attr_reader :id, :planet_id, :lines

  # Processes the given Array, representing the lines of the logfile, as a hash
  # with the line number as key and the content of the line as value.
  #
  # @return [ Hash ]
  def lines_init(content)
    i = 0
    to_return = {}
    content.map do |line|
      to_return[i.to_s] = line
      i += 1
    end
    to_return
  end

  # The name of the planet.
  #
  # @return [ String ]
  def planet
    Planet.find(planet_id).name
  end

  # Returns the contents of a logfile as a Hash-Array
  #
  # @return [ Array<Hash> ]
  def lines
    ary = []
    @lines.each do |key, value|
      ary.push(
        file_id:    @id,
        planet_id:  @planet_id,
        line:       key,
        content:    value
      )
    end
    ary
  end

  def self.bad_request?(file_id)
    return true if file_id.include?('&')
    return true if file_id.include?('"')
    return true if file_id.include?("'")
    return true if file_id.include?('\\')
    false
  end
end
