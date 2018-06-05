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

class LogFileProxy
  # Proxy handles the retrival of log files from the planet.
  #
  # @param [ String ]       planet_id The ID of the planet.
  # @param [ SFTP::Session] sftp      The connected SFTP session to the planet.
  #
  # @return [ Void ]
  def initialize(planet_id, sftp)
    @planet_id = planet_id
    @sftp      = sftp
    @plc_ids   = {}
  end

  # Find all log files on the planet.
  #
  # @return [ Array<LogFile> ]
  def find_all
    folders.each_with_object([]) do |args, files|
      files.concat(@sftp.dir.glob(*args).map! do |e|
        LogFile.new(e, @planet_id, @sftp, plc_id(e.name))
      end)
    end
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
    ISS::LFV.config['files']
  end

  # The content of the tcp_config file on the planet.
  #
  # @return [ Array<String> ]
  def tcp_config
    @sftp.read('km/cfg/tcp_config').to_s.split("\n")
  rescue
    []
  end

  # Find the PLC identifier for the node.
  #
  # @param [ String ] path The file path of the tcp_trace file.
  #
  # @return [ String ] nil if not found.
  def plc_id(path)
    node   = path.split('/tcp_trace.')[-1]
    plc_id = @plc_ids[node]

    return plc_id if plc_id || @plc_ids.any?

    (lines = tcp_config).each_with_index do |line, index|
      next if line[0...3] != 'TCP' || line.include?('#')

      id  = line.split[1]
      akz = lines[index - 1][1..-1].to_s.split(';')[0]&.strip

      @plc_ids[id] = akz
    end

    @plc_ids[node]
  rescue
    nil
  end
end
