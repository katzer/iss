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
  def initialize(id, planet_id, name)
    @id         = id
    @planet_id  = planet_id
    @name       = name
  end

  attr_reader :id, :planet_id, :name

  # The name of the planet.
  #
  # @return [ String ]
  def planet
    Planet.find(@planet_id).name
  end

  # Returns the contents of a logfile as a Hash-Array
  #
  # @return [ Array<Hash> ]
  def lines
    ary = []
    ISS::Ski.new.logfile(@id, @planet_id).each_with_index do |l, i|
      ary << { file_id: @id, planet_id: @planet_id, line: i.to_s, content: l }
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

  def to_h
    {
      id:        @id,
      planet_id: @planet_id,
      name:      @name
    }
  end
end
