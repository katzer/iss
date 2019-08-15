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

class ReportProxy < BasicObject
  # Proxy between a job and its reports.
  #
  # @param [ String ] job_id The ID of the job.
  #
  # @return [ Void ]
  def initialize(job_id)
    @job_id = job_id
  end

  # All reports associated with the job.
  #
  # @return [ Array<Report> ]
  def find_all
    dir = File.join(Report.path, @job_id)
    ext = '.skirep'

    return [] unless Dir.exist?(dir)

    Dir.entries(dir)
       .keep_if { |f| f[-7, 7] == ext }
       .map! { |f| Report.new(f.chomp!(ext), @job_id) }
  end

  # All reports associated with the job.
  #
  # @param [ String ] id The ID of the report.
  #
  # @return [ Report ] nil if not found.
  def find(id)
    report = Report.new(id, @job_id)

    report if File.file? report.path
  end
end
