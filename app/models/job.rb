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

class Job
  # Find of all jobs and return their ids.
  #
  # @return [ Array<String> ]
  def self.find_ids
    return [] unless Dir.exist? JOBS_FOLDER

    Dir.entries(JOBS_FOLDER)
       .keep_if { |f| f.end_with? '.json' }
       .map! { |f| f.chomp! '.json' }
  end

  # Find of all jobs.
  #
  # @return [ Array<Job> ]
  def self.find_all
    find_ids.map! { |id| new(id) }
  end

  # Find a job by id.
  #
  # @param [ String ] id The job id.
  #
  # @return [ Job ]
  def self.find(id)
    new(id) if exist? id
  end

  # Check if a job exists.
  #
  # @param [ String ] id The job id to check for.
  #
  # @return [ Boolean ]
  def self.exist?(id)
    find_ids.include? id
  end

  # Private Initializer for a job by id.
  #
  # @param [ String ] id The job id.
  #
  # @return [ Job ]
  def initialize(id)
    @id = id.to_s
  end

  def getid
    @id
  end

  attr_reader :id

  # Converts the report into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    { id: @id, name: @id }
  end

  # List of reports associated to the job.
  #
  # @return [ Array<Report> ]
  def reports
    dir = File.join(REPORTS_FOLDER, @id)

    return [] unless Dir.exist? dir

    Dir.entries(dir)
       .keep_if { |f| f.end_with? '.json' }
       .map! { |f| Report.new(f.chomp!('.json'), @id) }
  end
end