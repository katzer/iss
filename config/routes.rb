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

get '/api/stats',              controller: StatsController, action: 'stats'
get '/api/stats/{type}/count', controller: StatsController, action: 'count'
get '/api/stats/{type}/list',  controller: StatsController, action: 'list'

get '/api/jobs', controller: JobsController, action: 'jobs'
get '/api/jobs/{job_id}/reports', controller: JobsController, action: 'reports'
get '/api/jobs/{job_id}/reports/{report_id}/results', controller: JobsController, action: 'results'

get '/api/lfv/planets', controller: FilesController, action: 'planets'
get '/api/lfv/planets/{planet_id}/files', controller: FilesController, action: 'files'
get '/api/lfv/planets/{planet_id}/file', controller: FilesController, action: 'file'
