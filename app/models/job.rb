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

  # Find of all jobs and return their ids.
  #
  # @return [ Array<String> ]
  def self.find_ids
    return [] unless Dir.exist? FOLDER

    Dir.entries(FOLDER)
       .keep_if { |f| f.end_with? '.json' }
       .map! { |f| f.chomp! '.json' }
       .sort!
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

  attr_reader :id

  # List of reports associated to the job.
  #
  # @return [ Array<Report> ]
  def reports
    dir = File.join(Report::FOLDER, id)

    return [] unless Dir.exist? dir

    Dir.entries(dir)
       .keep_if { |f| f.end_with? '.json' }
       .sort!
       .map! { |f| Report.new(f.chomp!('.json'), id) }
  end

  # Converts the object into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    { id: id, name: id }
  end
end
