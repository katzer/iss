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

class JobsController < ApplicationController
  # Render all jobs found under the jobs folder.
  #
  # @return [ Void ]
  def jobs
    render(json: Job.find_all.map!(&:to_a))
  end

  # Render all reports for a given job.
  #
  # @return [ Void ]
  def reports(*)
    render json: job.reports.find_all.map!(&:to_a) if job
  end

  # Render all results for a given job and report.
  #
  # @return [ Void ]
  def results(*)
    render_cache 0.1, json: report.results.map!(&:to_a) if report
  end

  private

  # The requested job.
  #
  # @return [ Job ] nil if not found.
  def job
    job = Job.find(params[:job_id])
  ensure
    render 404 unless job
  end

  # The requested report.
  #
  # @return [ Job ] nil if not found.
  def report
    report = job&.reports&.find(params[:id])
  ensure
    render 404 unless report
  end
end
