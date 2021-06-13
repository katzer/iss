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

class LogContentProxy
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
    rule = find_ts_rule
    pos  = 0

    lines = read(size).map! do |line|
      LogContent.new(@id, @planet_id, pos += 1, line)
    end

    lines.inject(nil) { |ts, l| l.parse_ts(rule, ts) } if rule

    lines
  end

  private

  # Read the whole file from remote.
  #
  # @param [ Int ] size The amount of bytes to read.
  #
  # @return [ Array<String> ]
  def read(size)
    str = case size <=> 0
          when 0  then @sftp.read(@file_path)
          when 1  then @sftp.read(@file_path, size)
          when -1 then @sftp.read(@file_path, -size, size)
          end || ''

    str.from_latin9! if convert_from_latin?

    str.split("\n")
  end

  # The rule where to find the timestamp.
  #
  # @return [ Array ] nil if there's no rule.
  def find_ts_rule
    settings[:lfv][:timestamps]&.find do |rule|
      File.fnmatch? rule[0], @file_path, File::FNM_PATHNAME | rule[1]
    end
  end

  # Test if the content of the file has to be converted from Latin to UTF.
  #
  # @return [ Boolean ]
  def convert_from_latin?
    settings[:lfv][:encodings]&.any? do |pat, charset|
      charset == :latin && File.fnmatch?(pat, @file_path, File::FNM_PATHNAME)
    end
  end
end
