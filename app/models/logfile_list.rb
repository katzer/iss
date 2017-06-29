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


class Logfile_List
  # Initializes a job report by id and its job id.
  #
  # @return [ Orbit::Report ]
  def initialize(path, planet_id, logfile_name)
    @id         = path
    @planet_id  = planet_id
    @name       = logfile_name
  end

  attr_reader :id, :planet_id, :name

  # # The absolute path to the report file.
  # #
  # # @return [ String ]
  # def path
  #   File.join(REPORTS_FOLDER, @job_id, "#{id}.json")
  # end TODO reimplement

  # Converts the report into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    {
      id:         @id,
      planet_id:  @planet_id,
      name:       @name
    }
  end

end
