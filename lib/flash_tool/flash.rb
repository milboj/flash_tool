module FlashTool

  
  class Flash
    attr :input
    attr :args
    attr_reader :output_path
    attr_reader :info


    def initialize(input, command ,tempfile = nil, &block)
      @args = []
      @tempfile = tempfile
      @input = input
      @command = command
      yield self if block_given?
      raise FlashToolError, "File not found" unless File.exist?(input)
    end



    #
    def save(output_path=nil)
      if output_path
        @output_path = output_path
        @args << "--output"
        @args << output_path
      end
      run_command(@command,*@args << @input)
      @info = FlashTool.flash_info(@output_path)
    end


    def method_missing(symbol, *args)
      @args << ("--#{symbol}")
      @args +=(args)
    end

    private

    def +(value)
      @args << "+#{value}"
    end


    def run_command(command ,*args)
      args.collect! do |arg|
        # args can contain characters like '>' so we must escape them, but don't quote switches
        if arg !~ /^[\+\-]/
          "\"#{arg}\""
        else
          arg.to_s
        end
      end
      command = "#{command} #{args.join(" ")}"
      output = `#{command} 2>&1`

      if $?.exitstatus != 0
        raise FlashToolError, "SWF command (#{command.inspect}) failed: #{{:status_code => $?, :output => output}.inspect}"
      else
        output
      end
    end

  end


end