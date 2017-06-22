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

get '/iss' do
  render redirect: '/iss/index.html'
end

# get '/fifa' do |r|
#   query = ['--no-color'] + r.query.split(/&|%20/)
#   query.unshift '-f=json' unless r.query.include? '-f='

#   output, = Open3.capture3('fifa', *query)

#   if query - %w[-p -v -h] != query
#     html output
#   elsif query - %w[-c -t] != query
#     json output.split("\n")
#   elsif !query.include?('-f=json')
#     json output.split("\n")
#   else
#     json "[#{output.split("\n").join(',')}]"
#   end
# end

get '/api/jobs' do
  render json: Orbit::Job.find_all.map!(&:to_h)
end

get '/api/jobs/{job_id}/reports' do |job_id|
  job = Orbit::Job.find(job_id)
  job ? render(json: job.reports.map!(&:to_h)) : render(404)
end

get '/api/jobs/{job_id}/reports/{report_id}/results' do |job_id, report_id|
  job    = Orbit::Job.find(job_id)
  report = job.reports.find { |r| r.id == report_id } if job
  report ? render(json: report.results.map!(&:to_h)) : render(404)
end
