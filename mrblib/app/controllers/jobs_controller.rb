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

class JobsController < Yeah::Controller
  # Render all jobs foind under the jobs folder.
  #
  # @return [ Void ]
  def jobs
    render json: Job.find_all.map!(&:to_h)
  end

  # Render all reports for a given job.
  #
  # @param [ String ] job_id The ID of the job to look for.
  #
  # @return [ Void ]
  def reports(job_id)
    job = Job.find(job_id)

    job ? render(json: job.reports.map!(&:to_h)) : render(404)
  end

  # Render all results for a given job and report.
  #
  # @param [ String ] job_id    The ID of the job to look for.
  # @param [ String ] report_id The ID of the report to look for.
  #
  # @return [ Void ]
  def results(job_id, report_id)
    job    = Job.find(job_id)
    report = job.reports.find { |r| r.id == report_id } if job

    report ? render(json: report.results.map!(&:to_h)) : render(404)
  end
end
