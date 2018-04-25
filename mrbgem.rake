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

require_relative 'mrblib/version'

MRuby::Gem::Specification.new('iss') do |spec|
  spec.license = 'Apache 2.0'
  spec.author  = 'Sebastián Katzer, appPlant GmbH'
  spec.version = ISS::VERSION
  spec.bins    = ['iss']

  spec.rbfiles += Dir.glob("#{spec.dir}/{app,config}/**/*.rb").sort

  spec.add_dependency 'mruby-print'
  spec.add_dependency 'mruby-io', core: 'mruby-io'
  spec.add_dependency 'mruby-logger'
  spec.add_dependency 'mruby-ansi-colors'
  spec.add_dependency 'mruby-env'
  spec.add_dependency 'mruby-dir'
  spec.add_dependency 'mruby-os'
  spec.add_dependency 'mruby-json'
  spec.add_dependency 'mruby-hash-ext'
  spec.add_dependency 'mruby-array-ext'
  spec.add_dependency 'mruby-symbol-ext'
  spec.add_dependency 'mruby-yeah'
end
