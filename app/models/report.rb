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

class Report
  # Initializes a job report by id and its job id.
  #
  # @return [ Report ]
  def initialize(id, job_id)
    @id     = id
    @job_id = job_id
  end

  attr_reader :id, :job_id

  # The absolute path to the report file.
  #
  # @return [ String ]
  def path
    File.join(REPORTS_FOLDER, @job_id, "#{id}.json")
  end

  def getid
    @id
  end

  def getjob
    @job_id
  end

  # The timestamp when the report was created.
  #
  # @return [ String ]
  def timestamp
    "#{@id.gsub('_', ':')}Z" # rubocop:disable Performance/StringReplacement
  end

  # Max. list of columns extracted from linked result set.
  #
  # @return [ Array<String> ]
  def columns
    ['planet'] + results[0].rows.keys
  end

  # Converts the report into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    {
      id:        @id,
      name:      timestamp,
      timestamp: timestamp,
      job_id:    @job_id,
      columns:   columns
    }
  end

  # The raw result rows as seen in the report file.
  #
  # @return [ Array<Hash> ]
  def raw_results
    JSON.parse(IO.read(path))['planets']
  end

  # List of all report results.
  #
  # @return [ Array<ReportResult> ]
  def results
    res  = raw_results.map! { |row| Result.new(@job_id, @id, row) }
    cols = {}

    res.each { |r| cols.merge! r.rows }
    res.each { |r| cols.each_key { |col| r.rows[col] ||= '-' } }
    res
  end
end
