#
# Copyright (c) 2016 by appPlant GmbH. All rights reserved.
#
# @APPPLANT_LICENSE_HEADER_START@
#
# This file contains Original Code and/or Modifications of Original Code
# as defined in and that are subject to the Apache License
# Version 2.0 (the 'License'). You may not use this file except in
# compliance with the License. Please obtain a copy of the License at
# http://opensource.org/licenses/Apache-2.0/ and read it before using this
# file.
#
# The Original Code and all software distributed under the License are
# distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
# EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
# INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
# Please see the License for the specific language governing rights and
# limitations under the License.
#
# @APPPLANT_LICENSE_HEADER_END@

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
      define_singleton_method(name) { new(blk.call) }
    end

    # Initializes the tool with addition fixed args.
    #
    # @param [ String ] flags Fixed string of args.
    #
    # @return [ Void ]
    def initialize(flags = '')
      @args = merge_args(flags, self.class.args || '')
      @tail = flags.is_a?(String) ? '' : flags[:tail]
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

      "#{path} #{opts} #{tail.strip}".strip
    end

    # Execute a command specified by the flags.
    #
    # @param [ Hash ] flags The flags how to call the tool.
    # @param [ Array ] opts List of single key opts.
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
    # @return [ String, Process::Status ] The result and the process status.
    def exec(cmd)
      [`#{cmd}`.split("\n"), $?]
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
