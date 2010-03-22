require 'flash.rb'
module FlashTool
  class FlashObject < Flash
    attr_reader :info
    attr_reader :type

    # Input is path file with good extesnion
    # Approved formats are :
    # *pdf,
    # *jpeg (jpeg and jpg extension),
    # *png,
    # *gif,
    # *fonts (ttf, afm,  pfa, pfb formats) and
    # *wav (wav funcionality is untested and you can often will have problems with SWFTools installation  and with command wav2swf)
    #
    # type - is extension name string if your input file have other extension
    #
    # == Example
    #  flash = FlashOjbect.new('path_to_file', 'png')
    #
    #  flash = FlashOjbect.new('path_to_file.jpg') do |f|
    #  f.quality(80)
    #  f.rate('24')
    #  f.save('outputh_path')
    #  end
    #
    # Raise exceptions
    def initialize(input, type = nil, tempfile = nil, &block)
      @type = type || input.split('.').last
      @command = type_parser @type
      super(input,@command,tempfile,&block)
      
    end


    def self.from_blob(blob, ext, &block)
      begin
        tempfile = Tempfile.new(['swf_tool', ext.to_s])
        tempfile.binmode
        tempfile.write(blob)
      ensure
        tempfile.close if tempfile
      end

      return self.new(tempfile.path, ext ,tempfile, &block)
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

 
  end

end