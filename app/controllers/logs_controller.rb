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
      render_cache :logs, json: FindAllLogFiles.of_planet(planet_id)
    end
  end

  # Render the content of a log file.
  #
  # @return [ Void ]
  def show(*)
    try_twice do
      if accessible_logfile?
        render json: ReadContent.of_log_file(path, planet_id: planet_id, size: params['size'].to_i)
      else
        render 404
      end
    end
  end

  private

  # The converted file path.
  #
  # @return [ String ]
  def path
    @path ||= LogFile.id2path(params[:path])
  end

  # The proved id of the planet from the request.
  #
  # @return [ String ]
  def planet_id
    params[:id]
  end

  # Checks if the provided planet id matches the milky way.
  #
  # @return [ Boolean ]
  def milky_way?
    planet_id == Galaxy::MILKY_WAY_ID
  end

  # Validate if logfile is allowed to access.
  #
  # @return [ Boolean ]
  def accessible_logfile?
    valid_planet? && valid_path?
  end

  # Validate if path is allowed to access.
  #
  # @return [ Boolean ]
  def valid_path?
    return settings.dig(:groups, path) if milky_way?
    settings[:files].any? { |p| File.fnmatch?(p[0], path, p[1].to_i) }
  end

  # Validates if planet is allowed to access.
  #
  # @return [ Boolean ]
  def valid_planet?
    FindPlanet.by_id(planet_id)
  end

  # Execute the code twice incase of a SSH/SFTP exeception occurs.
  #
  # @param [ Proc ] The code block to execute.
  #
  # @return [ Void ]
  def try_twice
    yield
  rescue SSH::Exception, SFTP::Exception => e
    @retried ? raise(e) : (@retried = true) && retry
  rescue NotFoundError
    render 404
  end
end
