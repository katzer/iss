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

root '/iss/index.html'

get '/index.html' do
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

get '/api/jobs', controller: JobsController, action: 'jobs'
get '/api/jobs/{job_id}/reports', controller: JobsController, action: 'reports'
get '/api/jobs/{job_id}/reports/{report_id}/results', controller: JobsController, action: 'results'

get '/api/lfv/planets', controller: FilesController, action: 'planets'
get '/api/lfv/planets/{planet_id}/files', controller: FilesController, action: 'files'
get '/api/lfv/planets/{planet_id}/file', controller: FilesController, action: 'file'
