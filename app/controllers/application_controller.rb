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

class ApplicationController < Yeah::Controller
  # HTTP Cache-Control header with max-age.
  #
  # @param [ Symbol ] key The config name where to find the max-age value.
  #
  # @return [ Hash ] 'Cache-Control' => 'max-age=seconds'
  def cache_control(key)
    { 'Cache-Control' => "max-age=#{max_age(key).round}" }
  end

  # Render the response by adding the Cache-Control tag to the headers.
  #
  # @param [ Symbol ] key The config name where to find the max-age value.
  # @param [ Hash<Symbol,String> ] hsh The response data to render.
  #
  # @return [ Array ] The shelf response
  def render_cache(age, hsh)
    render hsh.merge!(headers: cache_control(age))
  end

  # The value for max-age header.
  #
  # @param [ Symbol ] key The config name where to find the value.
  #
  # @return [ Float ] age The age in seconds.
  def max_age(key)
    3600 * (settings.dig(:lfv, :'cache-controls', key) || 0)
  end
end
