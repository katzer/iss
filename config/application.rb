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

Yeah.application.configure do
  ##
  # Checks $ORBIT_HOME variable if its set and has a valid value.
  ##
  raise '$ORBIT_HOME not set'   unless ENV['ORBIT_HOME']
  raise '$ORBIT_HOME not a dir' unless File.directory? ENV['ORBIT_HOME']

  ##
  # Checks $ORBIT_KEY variable if its set and has a valid value.
  ##
  raise '$ORBIT_KEY not set'    unless ENV['ORBIT_KEY']
  raise '$ORBIT_KEY not a file' unless File.file? ENV['ORBIT_KEY']

  ##
  # Loads the config settings for the log file viewer.
  ##
  settings[:lfv] = JSON.parse(IO.read("#{ENV['ORBIT_HOME']}/config/lfv.json"))
                       .transform_keys!(&:to_sym)

  ##
  # Transform config settings for the log file viewer.
  ##
  settings[:lfv][:planets] = [settings[:lfv][:planets]].flatten.join(' ')
  settings[:lfv][:files]&.map! { |f| f.is_a?(Array) ? f : [f, 0] }
  settings[:lfv][:encodings]&.transform_values!(&:to_sym)

  ##
  # Tells the shelf server to accept socket connections in non-blocking mode.
  ##
  set :nonblock, OS.posix?

  ##
  # Tells the shelf server to invoke the GC after each request.
  ##
  set :run_gc_per_request, OS.windows?

  ##
  # Enables support for compression in production mode.
  ##
  middleware['production'] << [
    Shelf::Deflater, {
      include: ['text/html', 'text/css', 'application/js', 'application/json'],
      if: ->(*, body) { body.first.length >= 1400 }
    }
  ]

  ##
  # Tells Shelf where to find the static assets.
  ##
  document_root "#{ENV['ORBIT_HOME']}/public", urls: ['/iss']
end
