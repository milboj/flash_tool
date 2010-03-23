
require File.join(File.dirname(__FILE__), '../lib/flash_tool.rb')

require 'test/unit'

class Test_Flash_Script < Test::Unit::TestCase
  include FlashTool
  CURRENT_DIR = File.dirname(File.expand_path(__FILE__)) + "/test_files/"
  TEST_SCRIPT = CURRENT_DIR + "script.sc"
  BAD_SCRIPT = CURRENT_DIR + "bad.sc"

  def test_script_create
    output_file = "#{CURRENT_DIR}/script.swf"
    begin
      flash_object = FlashScript.new(TEST_SCRIPT)
      flash_object.save(output_file)
      assert(File.exist?(output_file))
    ensure
      File.delete(output_file)
    end
  end

  def test_bad_script
    output_file = "#{CURRENT_DIR}/script.swf"
    flash_object = FlashScript.new(BAD_SCRIPT)
    assert_raise(FlashToolError) { flash_object.save(output_file)}
  end

  def test_cgi_out
    
    flash_object = FlashScript.new(TEST_SCRIPT)
    assert_kind_of String, flash_object.cgi
  end

  def test_static_cgi_out

    flash_object = FlashScript.flash_data(TEST_SCRIPT)
    assert_kind_of String,  flash_object
  end

  def test_static_create

    output_file = "#{CURRENT_DIR}/script.swf"
    begin
      flash_object = FlashScript.create(TEST_SCRIPT, output_file)
      assert(File.exist?(output_file))
    ensure
      File.delete(output_file)
    end
  end

end
