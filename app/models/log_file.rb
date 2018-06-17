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

class LogFile < BasicObject
  # Convert the id of the path into a file path.
  #
  # @param [ String ] id The path ID to convert.
  #
  # @return [ String ]
  def self.id2path(id)
    id.gsub('~', '/')
  end

  # Convert the path into a file ID.
  #
  # @param [ String ] path The path to convert.
  #
  # @return [ String ]
  def self.path2id(path)
    path.gsub('/', '~')
  end

  # Initializes a log file.
  #
  # @param [ SFTP::Entry  ] entry     A remote file entry.
  # @param [ String ]       planet_id The ID of the corresponding planet.
  # @param [ String ]       plc_id    The ID of the corresponding PLC.
  # @param [ SFTP::Session] sftp      The connected SFTP session to the planet.
  #
  # @return [ Void ]
  def initialize(entry, planet_id, sftp, plc_id = nil)
    @id        = LogFile.path2id(entry.name)
    @planet_id = planet_id
    @plc_id    = plc_id
    @entry     = entry
    @sftp      = sftp
  end

  # Returns the content of a logfile.
  #
  # @param [ Int ] size The amount of bytes to read.
  #                     Defaults to: nil (all)
  #
  # @return [ Array<Hash> ]
  def content(size = nil)
    (pos = 0) && read(size).map! { |l| [@id, @planet_id, pos += 1, l] }
  end

  # Converts the object into a hash struct.
  #
  # @return [ Hash ]
  def to_a
    [@id, @planet_id, @plc_id, @entry.name, @entry.stats&.size, @entry.stats&.mtime]
  end

  private

  # Read the whole file from remote.
  #
  # @param [ Int ] size The amount of bytes to read.
  #
  # @return [ Array<String> ]
  def read(size)
    case size <=> 0
    when 0  then @sftp.read(@entry.name)
    when 1  then @sftp.read(@entry.name, size)
    when -1 then @sftp.read(@entry.name, -size, size)
    end.to_s.split("\n")
  end
end
