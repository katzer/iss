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

class Array
  # Maps all entries in parallel. All passed arguments will be forwarded as a
  # copy to the thread. If only one thread is needed the method simply acts like
  # Array#map!
  #
  # @param [Int] thread_count: The max thread pool size.
  #                            Default to: 20
  #
  # @return Array<>
  def parallel_map(*args, thread_count: 20, **kwargs, &block)
    return to_enum(:parallel_map!, *args, thread_count: thread_count, **kwargs) unless block
    return [] if empty?

    size = [self.size / thread_count, 1].max
    ths  = []

    if self.size <= size || thread_count == 1
      return self.map! { |it| block.call(it, *args, **kwargs) }.flatten!(1)
    end

    each_slice(size) do |slice|
      ths << Thread.new(slice, *args, **kwargs) do |slice, *args, **kwargs|
        slice.flat_map { |item| block.call(item, *args, **kwargs) }
      rescue => e
        [e]
      end
    end

    ths
      .map!(&:join)
      .flatten!(1)
      .to_a
      .each { |it| raise it if it.is_a?(Exception) }
  end
end
