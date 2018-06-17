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

class Result < BasicObject
  # Initializes a job report by id and its job id.
  #
  # @return [ Report ]
  def initialize(job_id, report_id, data)
    @job_id    = job_id
    @report_id = report_id
    @data      = data
  end

  attr_reader :job_id, :report_id

  # The id of the planet.
  #
  # @return [ String ]
  def planet_id
    @data['id']
  end

  # The name of the planet.
  #
  # @return [ String ]
  def planet
    Planet.find(planet_id)['name']
  rescue StandardError
    planet_id
  end

  # The parsed output values.
  #
  # @return [ Map ]
  def rows
    @data[:output].to_h
  end

  # Converts the object into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    {
      job_id:    job_id,
      report_id: report_id,
      planet_id: planet_id,
      valid:     !@data['errored'],
      planet:    planet
    }.merge!(rows)
  end
end
