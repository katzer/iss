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

module ISS
  # Wrapper for Orbit tools
  class Tool
    # Creates a new scope for the tool.
    #
    # @param [ Symbol ] name The name of the scope.
    # @param [ Proc ] blk The code block with returns the flags.
    #
    # @return [ ISS::Tool::Base ]
    def self.scope(name, blk)
      define_singleton_method(name) { |*args| new(blk.call(*args)) }
    end

    # Shortcut for Tool.new.call(...).
    #
    # @param [ Hash ] flags The flags how to call the tool.
    #
    # @return [ String, Process::Status ] The result and the process status.
    def self.call(flags = '')
      new.call(flags)
    end

    # Initializes the tool with addition fixed args.
    #
    # @param [ String ] flags Fixed string of args.
    #
    # @return [ Void ]
    def initialize(flags = '')
      @args = merge_args(flags, self.class.args || '')
      @tail = flags.is_a?(String) ? '' : flags.fetch(:tail, '')
    end

    attr_reader :args

    # The name of the binary.
    #
    # @return [ String ]
    def bin
      self.class.bin
    end

    # The absolute path to the binary.
    #
    # @return [ String ]
    def path
      self.class.path ? File.join(self.class.path, bin) : bin
    end

    # Build the shell command by joining path, bin, args and flags together.
    #
    # @param [ String ] flags Additional args.
    #
    # @return [ String ]
    def command(flags = '')
      opts = merge_args(flags, args)
      tail = flags.is_a?(String) ? @tail : "#{@tail} #{flags.fetch(:tail, '')}"

      "#{path} #{opts} #{tail.to_s.strip}".strip
    end

    # Execute a command specified by the flags.
    #
    # @param [ Hash ] flags The flags how to call the tool.
    #
    # @return [ String, Process::Status ] The result and the process status.
    def call(flags = '')
      exec command(flags)
    end

    private

    # Execute the given command.
    #
    # @param [ String ] cmd A bash command.
    #
    # @return [ String, Boolean ] The result and the process status.
    def exec(cmd)
      [`#{cmd}`.split("\n"), $? == 0]
    end

    # Merge the flags into the args without overriding existing ones.
    #
    # @param [ String ] flags Additional args.
    # @param [ String ] args Fixed args.
    #
    # @return [ String ]
    def merge_args(flags, args)
      flags = { args: flags } if flags.is_a? String

      opts  = Hash["#{flags[:args]} #{args}".split(' ')
                                            .map! { |opt| opt.split('=') }]

      opts.map { |opt| opt[1] ? opt.join('=') : opt[0] }.join(' ')
    end

    class << self
      attr_accessor :bin, :path, :args
    end
  end
end
