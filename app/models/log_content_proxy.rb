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

class LogContentProxy < BasicObject
  # Proxy handles the retrival of log files from the planet.
  #
  # @param [ String ]       file_path The path of the file.
  # @param [ String ]       planet_id The ID of the planet.
  # @param [ SFTP::Session] sftp      The connected SFTP session to the planet.
  #
  # @return [ Void ]
  def initialize(file_path, planet_id, sftp)
    @id        = LogFile.path2id(file_path)
    @file_path = file_path
    @planet_id = planet_id
    @sftp      = sftp
  end

  # Returns the content of a logfile.
  #
  # @param [ Int ] size The amount of bytes to read.
  #                     Defaults to: nil (all)
  #
  # @return [ Array<Hash> ]
  def readlines(size = nil)
    pos   = 0
    lines = read(size).map! { |l| LogContent.new(@id, @planet_id, pos += 1, l) }

    lines
  end

  private

  # Read the whole file from remote.
  #
  # @param [ Int ] size The amount of bytes to read.
  #
  # @return [ Array<String> ]
  def read(size)
    case size <=> 0
    when 0  then @sftp.read(@file_path)
    when 1  then @sftp.read(@file_path, size)
    when -1 then @sftp.read(@file_path, -size, size)
    end.to_s.split("\n")
  end
end
