# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.join(File.dirname(__FILE__), '../lib/flash_tool.rb')

require 'test/unit'

class Test_Flash_Data < Test::Unit::TestCase
  include FlashTool
  CURRENT_DIR = File.dirname(File.expand_path(__FILE__)) + "/test_files/"
  TEST_SWF = CURRENT_DIR + "tester.swf"
  BAD_FILE = CURRENT_DIR + "bad_ext.txt"
  JPG_SWF = CURRENT_DIR + "jpeg.swf"
  NO_FILE = CURRENT_DIR + "jpegswf.swf"
  BAD_SWF = CURRENT_DIR + "bad_swf.swf"
  
  def test_get_info
    info =  FlashTool.flash_info(TEST_SWF)
    assert_kind_of Hash, info
  end

  def test_missing_methods
    assert_kind_of(Integer, FlashTool.width(TEST_SWF))
    assert_kind_of(Integer, FlashTool.height(TEST_SWF))
    assert_kind_of(Integer, FlashTool.frames(TEST_SWF))
    assert_kind_of(Float, FlashTool.rate(TEST_SWF))
    assert_kind_of(String, FlashTool.html(TEST_SWF))
    assert_kind_of(String, FlashTool.xhtml(TEST_SWF))
    assert_kind_of(String, FlashTool.full(TEST_SWF))
    assert_kind_of(String, FlashTool.hex(TEST_SWF))
    assert_kind_of(String, FlashTool.buttons(TEST_SWF))
    assert_kind_of(String, FlashTool.placements(TEST_SWF))
    assert_kind_of(String, FlashTool.fonts(TEST_SWF))

  end

  def test_bad_file

    assert_raise(FlashToolError) { FlashTool.flash_info(BAD_FILE) }
    assert_raise(FlashToolError) { FlashTool.full(BAD_FILE) }
    assert_raise(FlashToolError) { FlashTool.width(BAD_FILE) }
    assert_raise(FlashToolError) { FlashTool.parse_text(BAD_FILE) }
    assert_raise(FlashToolError) { FlashTool.swfdump(BAD_FILE, 'width') }
  end

  def test_no_file

    assert_raise(FlashToolError) { FlashTool.flash_info(NO_FILE) }
    assert_raise(FlashToolError) { FlashTool.full(NO_FILE) }
    assert_raise(FlashToolError) { FlashTool.width(NO_FILE) }
    assert_raise(FlashToolError) { FlashTool.parse_text(NO_FILE) }
    assert_raise(FlashToolError) { FlashTool.swfdump(NO_FILE, 'width') }
  end

  # Testing bad swf
  def test_bad_swf_file

    assert_raise(FlashToolError) { FlashTool.flash_info(BAD_SWF) }
    assert_raise(FlashToolError) { FlashTool.full(BAD_SWF) }
    assert_raise(FlashToolError) { FlashTool.width(BAD_SWF) }
    assert_raise(FlashToolError) { FlashTool.parse_text(BAD_SWF) }
    assert_raise(FlashToolError) { FlashTool.swfdump(BAD_SWF, 'width') }
  end

  def test_parse_text
    assert_equal "",FlashTool.parse_text(JPG_SWF) #image flash
    assert (FlashTool.parse_text(TEST_SWF).length > 100 ) #test number of charachters
  end
end
