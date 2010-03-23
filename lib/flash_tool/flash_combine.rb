require File.dirname(__FILE__) + '/flash.rb'
module FlashTool

  #
  # This class work with tool swfcombine it is basic http://www.swftools.org/swfcombine.html
  # You can use every opticons for this command.
  # For adding master and slave swf files you must use methods master and slave
  # If you trying to use options
  #
  class FlashCombine < Flash


    #
    # Take two or more SWF files, and combine them into a new SWF file.
    # Can be used with or without master swf file
    #
    # ==Use
    # 
    #  combinated_file = FlashTool::FlashCombine.new
    #  combinated_file.master("master.swf")
    #  combinated_file.slave("viewport","slave.swf") #viewport is name of frame where can be placed slave
    #  combinated_file.rate(24)
    #  combinated_file.save("merged.swf")
    #
    #  cominated_file = FlashTool::FlashCombine.new do |f|
    #   f.master("master.swf")
    #   f.slave("viewport","slave.swf")
    #   f.output("merged.swf")
    #   f.save
    #  end
    #
    def initialize(&block)
      @args = []
      @slaves = []
      @command = "swfcombine"
      yield self if block_given?
    end

    #
    # With this method you will set master swf file for combining
    #
    # Can be only one master file
    #
    # Raise FlashToolError
    #
    def master(file)
      raise(FlashToolError, "Can be only one master swf file" ) if @master
      @master = file
    end
    
    #
    # With this method you will set slave swf file for combining 
    # 
    # Can be only one master file
    # 
    def slave(name, file)
      @slaves += ["#{name}=#{file}"]
    end

    #
    # Method save generate and run swfcombine command and generates file
    # Outputh path must be setted here or with method outputh before
    #
    # Raise error if output_path is not set.
    # 
    def save(output_path=nil)
      raise FlashToolError, "No output file name " if !@output_path and !output_path
      to_output_path(output_path)
      combiner
      run_command(@command,*@args)
      @info = FlashTool.flash_info(@output_path)
    end


    private
    def combiner
      @args.unshift(@master, @slaves)      
    end


  end
end