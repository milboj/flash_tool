module FlashTool

  
  class Flash

    attr :input
    attr :args

    # Path to file
    attr_reader :output_path

    # Hash with informations about generated file
    attr_reader :info


    #
    # This is basic method for generating command in swf tools
    # ==Example
    #  something = Flash.new("document.pdf","pdf2swf")do |f|
    #     f.rate(24)
    #     f.save("outputs.swf"
    #  end
    #
    # It is much easer to use other classes
    # *FlashObject - for work converting from other formats
    # *FlashScirpt - for generating files from scripts
    # *FlashCombine - for combining files
    #
    def initialize(input, command ,tempfile = nil, &block)
      @args = []
      @tempfile = tempfile
      @input = input
      @command = command
      yield self if block_given?
      raise FlashToolError, "File not found" unless File.exist?(input)
    end



    # Save swf file from documents
    # This method creates and run command
    # Output path can be defined in save method or in method output before
    # otherwise default file name will be same as input name document with swf extension
    def save(output_path=nil)
      to_output_path(output_path)
      run_command(@command,*@args << @input)
      @info = FlashTool.flash_info(@output_path)
    end



    # Setting options from command
    # List of commands and options can find here http://wiki.swftools.org/index.php/Main_Page
    # Optins with  "-" can't be executed in shorter form
    #
    def method_missing(symbol, *args)
      @output_path = args.to_s if symbol.to_s == "output"
      @args << ("--#{symbol}")
      @args +=(args)
    end


    protected

    # This method runs command
    def run_command(command ,*args)
      args.collect! do |arg|
        # args can contain characters like '>' so we must escape them, but don't quote switches
        if arg !~ /^[\-]/
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

    private

    # set output path before saveing
    def to_output_path(output_path) #:nodoc:
      unless @output_path
        if output_path
          @output_path = output_path
        else 
          @output_path = parse_nil_path(@input)
        end
        @args << "--output"
        @args << @output_path
      end
    end



    # Parsing file name and push new exetesnion if filename is not setted
    def parse_nil_path path #:nodoc:
      path = path.split('.')
      path.pop if path.length > 1
      path.push("swf")
      path.join('.')

    end

  end


end