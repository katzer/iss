# Apache 2.0 License
#
# Copyright (c) Copyright 2016 Sebastian Katzer, appPlant GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
    cols = columns

    rows.each do |row|
      row.each_with_index do |val, i|
        case cols[i][:type]
        when :int   then row[i] = val.to_i
        when :float then row[i] = val.to_f
        end
      end

      yield(row)
    end
  end
end
