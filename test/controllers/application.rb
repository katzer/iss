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

def env_for(path, query = '')
  { 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => path, 'QUERY_STRING' => query }
end

Yeah.run_initializers(@initializers)
app = Shelf::Server.new.build_app(app())

assert 'GET /', 'redirects to iss/index.html' do
  code, headers, = app.call env_for('/')

  assert_equal 303, code
  assert_equal '/iss/index.html', headers['Location']
end

assert 'GET /index.html', 'redirects to iss/index.html' do
  code, headers, = app.call env_for('/index.html')

  assert_equal 303, code
  assert_equal '/iss/index.html', headers['Location']
end

assert 'GET /iss/index.html' do
  code, _, body = app.call env_for('/iss/index.html')

  assert_equal 200, code
  assert_equal '<html>Yeah!</html>', body[0]
end
