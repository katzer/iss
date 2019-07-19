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
  # Integer column type
  INT    = 'int'.freeze
  # Float column type
  FLOAT  = 'float'.freeze

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
    [@id, @job_id, timestamp, columns]
  end

  # The absolute path to the report file.
  #
  # @return [ String ]
  def path
    File.join(FOLDER, @job_id, "#{@id}.skirep")
  end

  private

  # Open the report file and seek to the first result row.
  #
  # @param [ Proc ] yields the code block.
  #
  # @return [ Void ]
  def open_skirep_file
    File.open(path) { |f| f.seek(11) && yield(f, f.readline) }
  end

  # The timestamp when the report was created.
  #
  # @return [ Integer ]
  def timestamp
    File.read(path, 10).to_i
  end

  # Max. list of columns extracted from linked result set.
  #
  # @return [ Array<Hash> ]
  def columns
    @columns ||= open_skirep_file do |f, cols|
      JSON.parse(cols).each { |col| col[0].upcase! }
    rescue JSON::ParserError
      warn "#{f.path} is not a valid skirep file."
    end
  end

  # Convert each item in the report file into a result object.
  #
  # @return [ Array<Result> ]
  def results
    res = []

    open_skirep_file do |f|
      f.each do |row|
        res << Result.new(@job_id, @id, convert_cells(JSON.parse(row)))
      rescue JSON::ParserError
        warn "#{f.path} contains invalid json: #{row}"
      end
    end

    res
  end

  # Convert each cell by column type.
  #
  # @param [ Array ] row The row to convert.
  #
  # @return [ Array ]
  def convert_cells(row)
    valid, cells = row[2, 2]

    return row unless valid

    cells.each_with_index do |val, i|
      case columns[i][1]
      when INT   then cells[i] = val.to_i
      when FLOAT then cells[i] = val.to_f
      end
    end

    row
  end
end
