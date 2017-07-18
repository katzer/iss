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

class Ski
  def self.raw_logfile_list(id)
    command = '. ~/profiles/`whoami`.prof'
    LFV_CONFIG['files'].each do |cmd|
      command << ' && find ' << cmd
    end
    output = `ski -c='#{command}' #{id}`
    return nil unless $? == 0 # rubocop:disable Style/NumericPredicate
    output.split("\n")
  end

  # Returns specified logfile
  #
  # @return [ Logfile ]
  def self.logfile(file_name, id)
    output = `ski -c=\"cat #{file_name}\"  #{id}`

    return nil unless $? == 0 # rubocop:disable Style/NumericPredicate

    Logfile.new(file_name, id, output.split("\n"))
  end
end
