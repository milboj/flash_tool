require 'tempfile'

module FlashTool
  class FlashToolError < RuntimeError
  end

  # Creating flash swf files from pdf, jpg, png, gif and fonts file
  class FlashObject
    attr :input
    attr :type
    attr :args

    # Input is path file with good extesnion
    # Approved formats are :
    # *pdf,
    # *jpeg (jpeg and jpg extension),
    # *png,
    # *gif,
    # *fonts (ttf, afm,  pfa, pfb formats) and
    # *wav (wav funcionality is untested and you can often have problems with SWFTools installation with command wav2swf)
    #
    # type - is extension name string if your input file have other extension
    #
    # == Example
    #  flash = FlashOjbect.new('path_to_file', 'png')
    #
    # Raise exceptions
    def initialize(input,type = nil, tempfile = nil)
      @args = []
      @tempfile = tempfile
      @input = input
      @type = type || input.split('.').last
      @command = type_parser(@type)

      raise FlashToolError, "File not found" unless File.exist?(input)
    end


    def self.from_blob(blob, ext)
      begin
        tempfile = Tempfile.new(['swf_tool', ext.to_s])
        tempfile.binmode
        tempfile.write(blob)
      ensure
        tempfile.close if tempfile
      end

      return self.new(tempfile.path, ext ,tempfile)
    end

    #
    def save(output_path=nil)
      if output_path
        @args << "--output"
        @args << output_path
      end
      run_command(@command,*@args << @input)
    end

    


    def method_missing(symbol, *args)
      @args << ("--#{symbol}")
      @args +=(args)
    end

    private

    def type_parser input
      case input.downcase
      when "pdf"
        command = "pdf2swf"
      when "jpg", "jpeg"
        command = "jpeg2swf"
      when "png"
        command = "png2swf"
      when "gif"
        command = "gif2swf"
      when "ttf", "afm",  "pfa", "pfb"
        command = "font2swf"
      when "wav"
        command = "wav2swf"
      else
        raise FlashToolError, "Invalid type"
      end
      return command
    end

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




  # This method parse text from swf file.
  # File must have extension swf
  def FlashTool.parse_text(file)
    # something is bad with this program don't send errors, and ther is no need to check for errors
    # we must check file first
    # by documetation swfdump --text need to do this but
    raise FlashToolError, "File missing path: #{file}" unless File.exist?(file)
    raise FlashToolError, "Wrong file type SWF path: #{file} "  unless file =~ /(.swf)$/i
    command = "swfstrings #{file}"
    output = `#{command} 2>&1`
    # if file have appropiate name but is something is wrong with him
    raise FlashToolError, output if output =~/(errors.)$/
    return output
  end

  def FlashTool.method_missing(option, file)
    text = self.swfdump(file, option)
    option = option.to_s
    if option == "width" || option == 'height' || option == 'frames'
      return text.split(' ').last.to_i
    elsif option == 'rate'
      return text.split(' ').last.to_f
    else
      return text
    end
  end

  ###
  # Returns hash value with basic flash parameters
  # Keys are [width, rate, height, frames] and
  # values are kind of string
  def FlashTool.flash_info(file)
    args = ['width', 'rate', 'height', 'frames']
    data = swfdump(file, args)
    data.gsub!(/(-X)/, "width ")
    data.gsub!(/(-Y)/, "height ")
    data.gsub!(/(-r)/, "rate ")
    data.gsub!(/(-f)/, "frames ")

    return Hash[*data.split(' ')]

  end


  ###
  # This  method is very similar to swfdump command http://www.swftools.org/swfdump.html
  # Use longer options for this commands without --
  # DON'T use option text that option don't work
  # ==Examples
  #  FlashTool.swfdump('test.swf', 'rate')
  #
  #  FlashTool.swfdump('test.swf', ['rate','width','height']
  def FlashTool.swfdump(file, option=nil)
    command = 'swfdump'
    if option
      if option.kind_of? Array
        option.collect! { |a|   "--#{a}" }
        option = option.join(' ')
      else
        option = "--#{option}"
      end
    end

    command = "#{command} #{option} #{file}"

    output = `#{command} 2>&1`
    if $?.exitstatus != 0
      raise FlashToolError, "SWF command : #{command.inspect} failed : #{{:status_code => $?, :output => output}.inspect}"
    else
      return output
    end
  end
end



