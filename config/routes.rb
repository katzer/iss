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

Yeah.application.routes.draw do
  root '/iss/index.html'

  redirect '/index.html' => '/iss/index.html'

  get '/embed/lfv/{planet}' do |id|
    render redirect: "/iss/index.html#!lfv/#{id}"
  end

  get '/stats',                              to: 'stats'
  get '/stats/{type}/count',                 to: 'stats#count'
  get '/stats/{type}/list',                  to: 'stats#list'

  get '/jobs',                               to: 'jobs#jobs'
  get '/jobs/{job_id}/reports',              to: 'jobs#reports'
  get '/jobs/{job_id}/reports/{id}/results', to: 'jobs#results'

  get '/planets',      to: 'planets'
  get '/planets/{id}', to: 'planets#show'

  get '/planets/{id}/logs',        to: 'logs'
  get '/planets/{id}/logs/{path}', to: 'logs#show'
end
