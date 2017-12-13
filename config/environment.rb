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

raise '$ORBIT_HOME not set' unless ENV['ORBIT_HOME']
raise '$ORBIT_FILE not set' unless ENV['ORBIT_FILE']

ORBIT_HOME     = ENV['ORBIT_HOME']
ORBIT_FILE     = JSON.parse(IO.read(ENV['ORBIT_FILE']))
JOBS_FOLDER    = File.join(ORBIT_HOME, 'jobs').freeze
REPORTS_FOLDER = File.join(ORBIT_HOME, 'reports').freeze

CONFIG_FOLDER  = File.join(ORBIT_HOME, 'config').freeze
LFV_CONFIG     = JSON.parse(IO.read(File.join(CONFIG_FOLDER, 'lfv.json'))).freeze

configure do
  # Folder where to find all static assets, e.g. the web app
  document_root File.join(ORBIT_HOME, 'public'), urls: ['/iss']
end
