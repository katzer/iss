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

module Enumerable
  ##
  #  call-seq:
  #    enum.each_with_object(obj) { |(*args), memo_obj| ... }  ->  obj
  #    enum.each_with_object(obj)                              ->  an_enumerator
  #
  #  Iterates the given block for each element with an arbitrary
  #  object given, and returns the initially given object.
  #
  #  If no block is given, returns an enumerator.
  #
  #     (1..10).each_with_object([]) { |i, a| a << i*2 }
  #     #=> [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
  #
  def each_with_object(obj, &block)
    return to_enum(:each_with_object, obj) unless block

    self.each {|*val| block.call(val.__svalue, obj) }
    obj
  end

  ##
  #  call-seq:
  #     enum.zip(arg, ...)                  -> an_array_of_array
  #     enum.zip(arg, ...) { |arr| block }  -> nil
  #
  #  Takes one element from <i>enum</i> and merges corresponding
  #  elements from each <i>args</i>.  This generates a sequence of
  #  <em>n</em>-element arrays, where <em>n</em> is one more than the
  #  count of arguments.  The length of the resulting sequence will be
  #  <code>enum#size</code>.  If the size of any argument is less than
  #  <code>enum#size</code>, <code>nil</code> values are supplied. If
  #  a block is given, it is invoked for each output array, otherwise
  #  an array of arrays is returned.
  #
  #     a = [ 4, 5, 6 ]
  #     b = [ 7, 8, 9 ]
  #
  #     a.zip(b)                 #=> [[4, 7], [5, 8], [6, 9]]
  #     [1, 2, 3].zip(a, b)      #=> [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
  #     [1, 2].zip(a, b)         #=> [[1, 4, 7], [2, 5, 8]]
  #     a.zip([1, 2], [8])       #=> [[4, 1, 8], [5, 2, nil], [6, nil, nil]]
  #
  #     c = []
  #     a.zip(b) { |x, y| c << x + y }  #=> nil
  #     c                               #=> [11, 13, 15]
  #

  def zip(*arg, &block)
    result = block ? nil : []
    arg = arg.map do |a|
      unless a.respond_to?(:to_a)
        raise TypeError, "wrong argument type #{a.class} (must respond to :to_a)"
      end
      a.to_a
    end

    i = 0
    self.each do |*val|
      a = []
      a.push(val.__svalue)
      idx = 0
      while idx < arg.size
        a.push(arg[idx][i])
        idx += 1
      end
      i += 1
      if result.nil?
        block.call(a)
      else
        result.push(a)
      end
    end
    result
  end
end
