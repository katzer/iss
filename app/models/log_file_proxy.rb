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

class LogFileProxy < BasicObject
  # Proxy handles the retrival of log files from the planet.
  #
  # @param [ String ]       planet_id The ID of the planet.
  # @param [ SFTP::Session] sftp      The connected SFTP session to the planet.
  #
  # @return [ Void ]
  def initialize(planet_id, sftp)
    @planet_id = planet_id
    @sftp      = sftp
  end

  # Find all log files on the planet.
  #
  # @return [ Array<LogFile> ]
  def find_all
    folders.each_with_object([]) { |args, files| files.concat(entries(*args)) }
  end

  # Find the specified log file by ID.
  #
  # @param [ String ] id The ID of the log file.
  #
  # @return [ LogFile ] nil if not found.
  def find(id)
    find_by_path(LogFile.id2path(id))
  end

  # Find the specified log file by path.
  #
  # @param [ String ] path The path of the log file.
  #
  # @return [ LogFile ] nil if not found.
  def find_by_path(path)
    LogFile.new(SFTP::Entry.new(path, nil, nil), @planet_id, @sftp)
  end

  # Test if the remote path does exist and point to a file.
  #
  # @param [ String ] path The remote path.
  #
  # @return [ Boolean ]
  def exist?(path)
    @sftp.exist? path
  end

  private

  # The remote folders where to look for log files.
  #
  # @return [ Array<Array<String>> ]
  def folders
    Yeah.application.settings[:lfv][:files]
  end

  # Returns an array containing all of the filenames in the given directory.
  #
  # @param [ String ] pattern A shell glob like pattern matcher.
  # @param [ Int ]    flags   File.fnmatch flags (case insensitive, etc.)
  #
  # @return [ Array<LogFile> ] The matching files or an empty array
  #                            in case of some SFTP errors.
  def entries(pattern, flags)
    @sftp.dir.glob(pattern, flags).map! do |entry|
      LogFile.new(entry, @planet_id, @sftp, tcp_config[entry.name])
    end
  rescue SFTP::FileError, SFTP::DirError, SFTP::NameError, SFTP::PathError
    []
  end

  # The content of the tcp_config file on the planet.
  #
  # @return [ ISS::TCPConfig ]
  def tcp_config
    @tcp_config ||= begin
                      ISS::TCPConfig.new(@sftp.read('km/cfg/tcp_config'))
                    rescue SFTP::FileError
                      {}
                    end
  end
end
