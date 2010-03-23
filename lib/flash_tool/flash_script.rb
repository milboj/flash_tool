require File.dirname(__FILE__) + '/flash.rb'
module FlashTool



  # Generates flash files from scripts and using swfc tool
  # More about this http://wiki.swftools.org/index.php/Swfc
  class FlashScript < Flash

    def initialize(input, tempfile = nil, &block)
      @command = "swfc"
      super(input,@command,tempfile,&block)
    end

    # Creates and return flash from  input script
    # Same as option cgi options, but don't create file
    def cgi
      @args << "--cgi"
      run_command(@command,*@args << @input)
    end

    # Creates and return flash from  input script
    def self.flash_data(input)
      return self.new(input).cgi
    end

    # Creates flash from  input script
    def self.create(input, output)
      return self.new(input).save(output)
    end


  end


end