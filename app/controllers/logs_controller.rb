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

class LogsController < ApplicationController
  # Render a list of all log files.
  #
  # @return [ Void ]
  def index(*)
    try_twice do
      render_cache 1, json: planet.logs.find_all.map!(&:to_a) if planet
    end
  end

  # Render the content of a log file.
  #
  # @return [ Void ]
  def show(*)
    try_twice do
      render json: file.readlines(params['size'].to_i).map!(&:to_a) if file
    end
  end

  private

  # The requested planet. Validates first if its allowed to ask for.
  #
  # @return [ Planet ]
  def planet
    planet = Planet.find(params[:id]) if valid_planet?
  ensure
    render 404 unless planet
  end

  # The requested log file. Validates first if its allowed to ask for.
  #
  # @return [ LogFile ]
  def file
    file = planet&.logs&.find_by_path(path) if valid_path? && file_exist?
  ensure
    render 404 unless file
  end

  # The converted file path.
  #
  # @return [ String ]
  def path
    @path ||= LogFile.id2path(params[:path])
  end

  # Validate if planet is allowed to access.
  #
  # @return [ Boolean ]
  def valid_planet?
    !fifa("-a=id #{params[:id]}", false).empty?
  end

  # Validate if planet is allowed to access.
  #
  # @return [ Boolean ]
  def valid_path?
    settings[:lfv][:files]&.any? { |p| File.fnmatch?(p[0], path, p[1].to_i) }
  end

  # Test if the remote path does exist.
  #
  # @return [ Boolean ]
  def file_exist?
    planet&.logs&.exist?(path)
  end

  # Delete the pooled sftp connection for the requested planet.
  #
  # @return [ Void ]
  def delete_pooled_sftp_connection
    settings[:pool].delete(params[:id])
  end

  # Execute the code twice incase of a SSH/SFTP exeception occurs.
  #
  # @param [ Proc ] The code block to execute.
  #
  # @return [ Void ]
  def try_twice
    yield
  rescue SSH::Exception, SFTP::Exception => e
    delete_pooled_sftp_connection
    @retried ? raise(e) : (@retried = true) && retry
  end
end
