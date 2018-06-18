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

class LogsController < Yeah::Controller
  # Render a list of all log files.
  #
  # @return [ Void ]
  def index(*)
    render json: planet.logs.find_all.map(&:to_a) if planet
  end

  # Render the content of a log file.
  #
  # @return [ Void ]
  def show(*)
    render json: file.content(params['size'].to_i) if file
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
    `fifa -a=id '#{params[:id]}'`.length > 1
  end

  # Validate if planet is allowed to access.
  #
  # @return [ Boolean ]
  def valid_path?
    Yeah.application.settings[:lfv][:files].any? do |p|
      File.fnmatch?(p[0], path, p[1].to_i)
    end
  end

  # Test if the remote path does exist.
  #
  # @return [ Boolean ]
  def file_exist?
    planet&.logs&.exist?(path)
  end
end
