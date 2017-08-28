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

class Logfile
  # If the file_id goes along with the rules for file id syntax.
  #
  # @param [ String ] file_id The ID of the file to check for.
  #
  # @return [ Boolean ]
  def self.valid?(file_id)
    %w[& " ' \\ \ ].none? { |token| file_id.include? token }
  end

  # Initializes a log file.
  #
  # @param [ String ] id        The Id (e.g. path) of the file.
  # @param [ String ] planet_id The ID of the planet where the file is located.
  #
  # @return [ Void ]
  def initialize(id, planet_id)
    @id         = id
    @planet_id  = planet_id
  end

  attr_reader :id, :planet_id

  # The name of the file
  #
  # @return [ String ]
  alias name id

  # If the id of the file goes along with the rules for file id syntax.
  #
  # @return [ Boolean ]
  def valid?
    self.class.valid? id
  end

  # Returns the contents of a logfile as a Hash-Array
  #
  # @return [ Array<Hash> ]
  def lines
    lines              = []
    output, successful = ISS::Ski.call tail: %(-c="cat #{id}" #{planet_id})

    return lines unless successful

    output.each_with_index do |l, i|
      lines << { file_id: id, planet_id: planet_id, line: i, content: l }
    end

    lines
  end

  # Converts the object into a hash struct.
  #
  # @return [ Hash ]
  def to_h
    { id: id, planet_id: planet_id, name: name }
  end
end
