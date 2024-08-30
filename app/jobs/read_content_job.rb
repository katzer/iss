# Apache 2.0 License
#
# Copyright (c) 2022 Sebastian Katzer
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

module ReadContent

  # Find all log files of a planet.
  #
  # @param [ String ] path      The path of the log file.
  # @param [ String ] planet_id The id of the planet.
  # @param [ String ] size      The amount of bytes to read.
  # @param [ Array] timestamps  Rules how to extract the timestamp.
  # @param [ Array] filters     Line filters.
  # @param [ Array] encodings   File excodings.
  #
  # @raise [ LogFileNotFound ]
  #
  # @return [ Array<LogFileContent> ]
  def self.of_log_file(path, planet_id:, **args)
    args[:timestamps]   ||= settings[:timestamps]
    args[:filters]      ||= settings[:filters]
    args[:encodings]    ||= settings[:encodings]

    if planet_id == Galaxy::MILKY_WAY_ID
      read_vlog_file(path, **args)
    else
      read_log_file(path, planet_id: planet_id, **args)
    end
  end

  private

  # Returns the content of a logfile.
  #
  # @param [ String ] path      The path of the log file.
  # @param [ String ] planet_id The id of the planet.
  # @param [ Int ] size The amount of bytes to read.
  # @param [ Array] timestamps Rules how to extract the timestamp.
  # @param [ Array] filters    Line filters.
  # @param [ Array] encodings  File excodings.
  #
  # @raise [ LogFileNotFound ]
  #
  # @return [ Array<LogContent> ]
  def self.read_log_file(path, planet_id:, size: 0, **args)
    sftp(planet_id) do |sftp|
      # raise LogFileNotFound unless sftp.exist? path
      file  = LogFile.new(SFTP::Entry.new(path, nil, nil), planet_id, sftp)
      lines = file.readlines(size, **args)

      lines.map!(&:to_a)
    end
  end

  # Returns the content of a virtual logfile.
  #
  # @param [ String ] path     The path of the log file.
  # @param [ Int ] size The amount of bytes to read.
  # @param [ Array] timestamps Rules how to extract the timestamp.
  # @param [ Array] filters    Line filters.
  # @param [ Array] encodings  File excodings.
  #
  # @return [ Array<LogContent> ]
  def self.read_vlog_file(path, thread_count: settings[:thread_count], **args)
    list = log_file_list(path, thread_count: thread_count)

    # if size != 0 && list.any?
    #   if size > 0
    #     size = [size.abs / list.size, 1].max
    #   else
    #     size = [(size.abs / list.size) * -1, -1].min
    #   end
    # end

    list.parallel_map(thread_count: thread_count, **args) do |(planet_id, path), **args|
      ReadContent.of_log_file(path, planet_id: planet_id, **args)
    end
    # TODO: sort by date
    #.each_with_index { |line, idx| line[2] = idx + 1 }
  end

  # Returns al list of all log files to read for the given virtual logfile.
  #
  # @param [ String ] group The name of the logfile group.
  #
  # @return [ Array<String,String>] List of tuples (path & planet)
  def self.log_file_list(group, thread_count:)
    matcher = settings.dig(:groups, group, :planets)
    planets = fifa("-a id #{matcher}")
    files   = settings.dig(:groups, group, :files)

    if planets.size > files.size
      planets.parallel_map(files, thread_count: thread_count) do |planet_id, files|
        FindAllLogFiles
          .of_planet(planet_id, folders: files, thread_count: 1)
          .map! { |file| file[1, 2] }
      end
    else
      planets.flat_map do |planet_id|
        FindAllLogFiles
          .of_planet(planet_id, folders: files, thread_count: thread_count)
          .map! { |file| file[1, 2] }
      end
    end
  end
end
