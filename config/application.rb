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

opt! :help do
  <<-usage

#{ISS::LOGO}

usage: iss [options...]
Options:
-e, --environment The environment to run the server with.
-h, --host        The host to bind the local server on.
                  Defaults to: 0.0.0.0
-p, --port        The port number to start the local server on.
                  Defaults to: 1974
-h, --help        This help text
-v, --version     Show version number
usage
end

opt! :version do
  "v#{ISS::VERSION} - #{OS.sysname} #{OS.bits(:binary)}-Bit (#{OS.machine})"
end

opt :environment, 'development' do |env|
  ENV['SHELF_ENV'] = env
end

opt :port, 1974 do |port|
  set :port, port.to_i
end

opt :host, 'localhost' do |host|
  set :host, host
end
