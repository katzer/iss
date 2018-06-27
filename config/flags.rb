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

Yeah.application.opts.draw do
  opt! :help do
    <<-USAGE

#{ISS::LOGO}

usage: iss [options...]
Options:
-e, --environment The environment to run the server with
-h, --host        The host to bind the local server on
                  Defaults to: 0.0.0.0
-p, --port        The port number to start the local server on
                  Defaults to: 1974
-r, --routes      Print out all defined routes
-s, --size        Max pool size for SFTP/SSH sessions
                  Defaults to: 5
-t, --timeout     Receive timeout before socket will be closed
                  Defaults to: 1 (sec)
-h, --help        This help text
-v, --version     Show version number
USAGE
  end

  opt! :version do
    "iss #{ISS::VERSION} - #{OS.sysname} #{OS.bits(:binary)}-Bit (#{OS.machine})"
  end

  opt! :routes do
    Yeah.application.routes.routes.sort.join("\n")
  end

  opt :environment, 'development' do |env|
    ENV['SHELF_ENV'] = env
  end

  opt :host do |host|
    set host: ENV['SHELF_ENV'] == 'production' ? '0.0.0.0' : host || 'localhost'
  end

  opt :port, :int, 1974 do |port|
    set :port, port
  ensure
    raise 'port cannot be zero' if port == 0
  end

  opt :timeout, :int, 1 do |timeout|
    set :timeout, timeout
  ensure
    raise 'timeout cannot be zero' if timeout == 0
  end

  opt :size, :int, 5 do |size|
    set :pool, ISS::Pool.new(size)
  ensure
    raise 'size cannot be zero' if size == 0
  end
end
