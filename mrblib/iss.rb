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

raise '$ORBIT_HOME not set' unless ENV['ORBIT_HOME']
raise '$ORBIT_FILE not set' unless ENV['ORBIT_FILE']

module Orbit
  ORBIT_HOME     = ENV['ORBIT_HOME']
  ORBIT_FILE     = JSON.parse(IO.read(ENV['ORBIT_FILE']))
  JOBS_FOLDER    = File.join(ORBIT_HOME, 'jobs').freeze
  REPORTS_FOLDER = File.join(ORBIT_HOME, 'reports').freeze

  # Find planet by id.
  #
  # @return [ Hash ]
  def self.find_planet(id)
    ORBIT_FILE.find { |planet| planet['id'] == id }
  end
end

# $stdout.close
# $stderr.close

# Dir.mkdir Orbit::LOGS_FOLDER unless Dir.exist? Orbit::LOGS_FOLDER
# $stdout = File.new "#{Orbit::LOGS_FOLDER}/iss.log", 'w'
# $stderr = File.new "#{Orbit::LOGS_FOLDER}/iss.err", 'w'
