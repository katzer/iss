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

module ISS
  # Class for SFTP Session pooling
  class Pool
    # Initialize a new session pool with given size.
    #
    # @param [ Int ] size The pool size. Set to nil for infinite.
    #                     Defaults to: 5
    #
    # @return [ Void ]
    def initialize(size = 5)
      @size     = size
      @sessions = {}
    end

    # The pool size.
    #
    # @return [ Int ]
    attr_reader :size

    # Returns the SFTP session for the given id. Might initate a session first
    # and/or clean up the oldest one first to keep the size.
    #
    # @param [ String ] id The id of the planet.
    #
    # @return [ SFTP::Session ]
    def [](id)
      session = @sessions[id]

      return session if session&.connected?

      cleanup_oldest if @sessions.size == @size && !@sessions.include?(id)

      session       = init_session(id)
      @sessions[id] = session if @size > 0

      session
    end

    # Delete a SFTP session from the session pool.
    #
    # @param [ String ] id The ID of the session to delete.
    #
    # @return [ SFTP::Session ] The deleted session object.
    def delete(id)
      @sessions.delete(id) if id
    end

    private

    # Start a new SFTP session for given planet by id.
    #
    # @param [ String ] id The id of the planet.
    #
    # @return [ SFTP::Session ]
    def init_session(id)
      user, host = fifa("-f ssh #{id}", false).chomp.split('@')

      SFTP.start(host, user, ssh_config)
    end

    # Configuration for SSH connection.
    #
    # @return [ Hash<Symbol,Object> ]
    def ssh_config
      { key: ENV.fetch('ORBIT_KEY'), compress: true, timeout: 5_000 }
    rescue KeyError
      raise '$ORBIT_KEY not set'
    end

    # Close the oldest SFTP session and remote it from the queue.
    #
    # @return [ Void ]
    def cleanup_oldest
      id, = @sessions.first

      delete(id)
    end
  end
end
