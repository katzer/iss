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

module ISS
  # Wrapper around Orbit ski tool
  class Ski < Tool
    self.bin = 'ski'

    def raw_logfile_list(id)
      command = '. ~/profiles/`whoami`.prof'
      LFV_CONFIG['files'].each do |cmd|
        command << ' && find ' << cmd
      end
       raw = call(tail: "-c='#{command}' #{id}")
       return nil if raw[1] != 0
       raw[0]
    end

    # Returns specified logfile
    #
    # @return [ Logfile ]
    def logfile(file_name, planet_id)
      raw = call(tail: "-c=\"cat #{file_name}\"  #{planet_id}")
      return nil if raw[1] != 0
      raw[0]
    end
  end
end
