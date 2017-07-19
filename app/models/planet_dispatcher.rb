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

class PlanetDispatcher
  # Scope for all planets of type server
  #
  # @return [ Array<Hash> ]
  def servers
    @fifa.servers.map { |p| Planet.new(p[:id], p[:name], p[:type]) }
  end

  # Scope for all planets of type server
  #
  # @return [ Array<Hash> ]
  def servers_for_lfv
    @fifa.servers_for_lfv.map { |p| Planet.new(p[:id], p[:name], p[:type]) }
  end

  # Checks, if a planet is valid.
  #
  # @return [ Boolean ]
  def valid?(planet_id)
    servers_for_lfv.any? { |p| p.id == planet_id }
  end

  # Find planet by id.
  #
  # @param [ String ] id The planet id.
  #
  # @return [ Planet ]
  def find(id)
    @fifa.planet(id) if valid? id
  end

  # Private Initializer for a planet dispatcher
  #
  # @return [ PlanetDispatcher ]
  def initialize()
    @ski  = Ski.new
    @fifa = Fifa.new
  end
end
