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

def fixture(file)
  File.read File.join(File.dirname(__FILE__), "../fixtures/#{file}")
end

assert 'test raw_logfile_list' do
  ski = Ski.new
  def ski.call(_)
    fixture('logfile_list')
  end
  logfile = ski.raw_logfile_list('localhost')[0]

  assert_equal logfile, '/home/mrblati/workspace/orbit/config/orbit.json'
end

assert 'test logfile' do
  ski = Ski.new
  def ski.call(_)
    fixture('logfile')
  end

  id = '/home/mrblati/workspace/orbit/config/orbit.json'
  line = ski.logfile(id,'localhost')[0]

  assert_equal line, 'this'
end








