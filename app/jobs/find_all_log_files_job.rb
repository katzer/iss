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

module FindAllLogFiles

  # Find all log files of a planet.
  #
  # @param [ String ] planet_id The id of the planet.
  # @param [ Array<Array<String>> ] folders The remote folders where to look for.
  # @param [ Int ] thread_count The number of parallel threads.
  #
  # @return [ Array<LogFile> ]
  def self.of_planet(planet_id, folders: settings[:files], thread_count: settings[:thread_count])
    if planet_id == Galaxy::MILKY_WAY_ID
      find_all_vlog_files
    else
      find_all_log_files(planet_id, folders.dup, thread_count: thread_count)
    end
  end

  private

  # LogFileProxy for the planet.
  #
  # @param [ String ] planet_id The id of the planet.
  # @param [ Array<Array<String>> ] folders The remote folders where to look for.
  # @param [ Int ] thread_count The number of parallel threads.
  #
  # @return [ Array<LogFile> ]
  def self.find_all_log_files(planet_id, folders, **args)
    folders.parallel_map(planet_id, **args) do |(pattern, flags), planet_id|
      sftp(planet_id) do |sftp|
        sftp.dir.glob(pattern, flags).map! do |entry|
          [
            LogFile.path2id(entry.name),
            planet_id,
            entry.name,
            entry.stats&.size,
            entry.stats&.mtime
          ]
        end
      rescue SFTP::FileError, SFTP::DirError, SFTP::NameError, SFTP::PathError
        []
      end
    end
  end

  # Find all virtual log files.
  #
  # @return [ Array<LogFile> ]
  def self.find_all_vlog_files
    settings[:groups].keys.map! do |name|
      [LogFile.path2id(name), Galaxy::MILKY_WAY_ID, name]
    end
  end
end
