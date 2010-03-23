require File.join(File.dirname(__FILE__), '../lib/flash_tool.rb')

require 'test/unit'

class Test_Flash_Combine < Test::Unit::TestCase
  include FlashTool
  CURRENT_DIR = File.dirname(File.expand_path(__FILE__)) + "/test_files/"
  TEST_SWF = CURRENT_DIR + "tester.swf"
  BAD_FILE = CURRENT_DIR + "bad_ext.txt"
  JPG_SWF = CURRENT_DIR + "jpeg.swf"
  NO_FILE = CURRENT_DIR + "jpegswf.swf"
  BAD_SWF = CURRENT_DIR + "bad_swf.swf"
  VIEW_SWF  = CURRENT_DIR + "rfxview.swf"

  def test_combine
    output_file = "#{CURRENT_DIR}/merge.swf"
    begin
      inputs = VIEW_SWF
      flash = FlashCombine.new()
      flash.master(inputs)
      flash.slave("viewport",TEST_SWF)
      flash.save(output_file)
      assert(File.exist?(output_file))
      assert_kind_of(Hash, flash.info)
      
    ensure
      File.delete(output_file)
    end
  end

  def test_combine_block
    output_file = "#{CURRENT_DIR}/merge.swf"
    begin
      inputs = VIEW_SWF
      flash = FlashCombine.new() do |f|
        f.master(inputs)
        f.slave("viewport",TEST_SWF)
        f.save(output_file)
      end
      assert_kind_of(Hash, flash.info)
      assert(File.exist?(output_file))
    ensure
      File.delete(output_file)
    end
  end

  def test_combine_without_save
    output_file = "#{CURRENT_DIR}/merge.swf"
    begin
      inputs = VIEW_SWF
      flash = FlashCombine.new() do |f|
        f.slave("viewport",TEST_SWF)
        f.method_missing("local-with-filesystem")
        f.method_missing("rate",50)
        f.master(inputs)        
        f.output(output_file)
        f.save()
      end
      assert_kind_of(Hash, flash.info)
      assert(File.exist?(output_file))
    ensure
      File.delete(output_file)
    end
  end

  def test_combine_no_output
    inputs = VIEW_SWF
    FlashCombine.new() do |f|
      f.master(inputs)
      f.slave("viewport",TEST_SWF)
      f.output()
      assert_raise(FlashToolError) {f.save()}
    end
  end

  def test_bad_inputs
    inputs = BAD_FILE
    FlashCombine.new() do |f|
      f.master(inputs)
      f.slave("viewport",TEST_SWF)
      f.output()
      assert_raise(FlashToolError) {f.save()}

    end

  end      
    
end