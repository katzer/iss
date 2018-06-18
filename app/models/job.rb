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

class Job < BasicObject
  # Path where to find all jobs
  FOLDER = File.join(ENV['ORBIT_HOME'], 'jobs').freeze

  # Find of all jobs.
  #
  # @return [ Array<Job> ]
  def self.find_all
    return [] unless Dir.exist? FOLDER

    Dir.entries(FOLDER)
       .keep_if { |f| f.end_with? '.json' }
       .map! { |f| new f.chomp!('.json') }
  end

  # Find a job by id.
  #
  # @param [ String ] id The job id.
  #
  # @return [ Job ]
  def self.find(id)
    new(id) if File.file? File.join(FOLDER, "#{id}.json")
  end

  # Private Initializer for a job by id.
  #
  # @param [ String ] id The job id.
  #
  # @return [ Job ]
  def initialize(id)
    @id = id.to_s
  end

  # The job id.
  #
  # @return [ String ]
  attr_reader :id

  # Proxy instance to find reports for the job.
  #
  # @return [ ReportProxy ]
  def reports
    ReportProxy.new(@id)
  end

  # Converts the object into an array struct.
  #
  # @return [ Array ]
  def to_a
    [@id, @id]
  end
end
