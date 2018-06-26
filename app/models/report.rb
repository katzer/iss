# Apache 2.0 License
#
# Copyright (c) 2016 Sebastian Katzer, appPlant GmbH
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
  # Path where to find all the reports
  FOLDER = File.join(ENV['ORBIT_HOME'].to_s, 'reports').freeze

  # Initializes a job report by id and its job id.
  #
  # @param [ String ] id     The id of the report.
  # @param [ String ] job_id The id of the job.
  #
  # @return [ Report ]
  def initialize(id, job_id)
    @id     = id
    @job_id = job_id
  end

  # The id of the report.
  #
  # @return [ String ]
  attr_reader :id

  # Converts the object into a hash struct.
  #
  # @return [ Hash ]
  def to_a
    [@id, @job_id, *Array.new(2, timestamp), columns]
  end

  private

  # The absolute path to the report file.
  #
  # @return [ String ]
  def path
    File.join(FOLDER, @job_id, "#{@id}.json")
  end

  # The timestamp when the report was created.
  #
  # @return [ String ]
  def timestamp
    "#{@id.gsub('_', ':')}Z"
  end

  # The parsed report json file.
  #
  # @return [ Hash ]
  def content
    @content ||= begin
      JSON.parse(IO.read(path))
    rescue JSON::ParserError
      warn "#{path} is not a valid json file."
    end
  end

  # The planet items of the parsed report.
  #
  # @return [ Hash ]
  def content_items
    content['planets'].tap do |items|
      ids   = items.map { |item| item['id'] }
      names = `fifa -a=name #{ids.join(' ')}`.split("\n")
      items.each_with_index { |item, idx| item[:planet] = names[idx] }
    end
  end

  # Max. list of columns extracted from linked result set.
  #
  # @return [ Array<Hash> ]
  def columns
    @columns ||= content['Keys'].to_s.split(',').map! do |name|
      name.strip!
      case name[-2, 2]
      when '_s' then [name[0...-2], :string]
      when '_i' then [name[0...-2], :int]
      when '_f' then [name[0...-2], :float]
      else           [name, :string]
      end
    end
  end

  # List of all report results.
  #
  # @return [ Array<ReportResult> ]
  def results
    content_items.each_with_object([]) do |item, items|
      _, *rows = JSON.parse(item['output'])

      with_each_converted_row(rows) do |row|
        items << Result.new(@job_id, @id, item.merge(output: row))
      end
    rescue JSON::ParserError
      warn "#{path} contains invalid json: #{item}"
    end
  end

  # Convert each cell by column type.
  #
  # @param [ Array] rows The list of rows.
  #
  # @return [ Void ]
  def with_each_converted_row(rows)
    rows.each do |row|
      row.each_with_index do |val, i|
        case columns[i][-1]
        when :int   then row[i] = val.to_i
        when :float then row[i] = val.to_f
        end
      end

      yield(row)
    end
  end
end
