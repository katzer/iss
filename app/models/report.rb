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
    File.join(REPORTS_FOLDER, job_id, "#{id}.json")
  end

  # The timestamp when the report was created.
  #
  # @return [ String ]
  def timestamp
    "#{@id.gsub('_', ':')}Z" # rubocop:disable Performance/StringReplacement
  end

  # Max. list of columns extracted from linked result set.
  #
  # @return [ Array<Hash> ]
  def columns
    @columns ||= content['Keys'].split(', ').map! do |name|
      case name[-2, 2]
      when '_s' then { id: name, name: name[0...-2], type: :string }
      when '_i' then { id: name, name: name[0...-2], type: :int    }
      when '_f' then { id: name, name: name[0...-2], type: :float  }
      else           { id: name, name: name,         type: :string }
      end
    end
  end

  # List of all report results.
  #
  # @return [ Array<ReportResult> ]
  def results
    content['planets'].each_with_object([]) do |item, items|
      keys, *rows = JSON.parse(item['output'])

      rows << Array.new(keys.size, '') if rows.empty?

      with_each_converted_row(rows) do |row|
        items << Result.new(job_id, id, item.merge(output: keys.zip(row)))
      end
    end
  end

  # Converts the object into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    {
      id:        id,
      name:      timestamp,
      timestamp: timestamp,
      job_id:    job_id,
      columns:   columns
    }
  end

  private

  # The parsed report json file.
  #
  # @return [ Hash ]
  def content
    @content ||= JSON.parse(IO.read(path))
  end

  # Convert each cell by column type.
  #
  # @param [ Array] rows The list of rows.
  #
  # @return [ Void ]
  def with_each_converted_row(rows)
    rows.each do |row|
      row.each_with_index do |val, i|
        case columns[i][:type]
        when :int   then row[i] = val.to_i
        when :float then row[i] = val.to_f
        end
      end

      yield(row)
    end
  end
end
