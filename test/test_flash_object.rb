# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib/flash_tool.rb')

class FlashToolsTest < Test::Unit::TestCase
  include FlashTool

  CURRENT_DIR = File.dirname(File.expand_path(__FILE__)) + "/test_files/"

  PDF_FILE  = CURRENT_DIR + "test.pdf"
  PDF_PASSW_PROTECTED = CURRENT_DIR + "test_with_password.pdf"
  GIF_FILE  = CURRENT_DIR + "25-1.gif"
  FONT_FILE = CURRENT_DIR + "liberationserif_bold.ttf"
  JPG_FILE  = CURRENT_DIR + "test.jpg"
  PNG_FILE  = CURRENT_DIR + "test.png"
  VIEW_SWF  = CURRENT_DIR + "rfxview.swf"



  def test_flash_object_from_blob
    File.open(JPG_FILE, "rb") do |f|
      flash_object = FlashObject.from_blob(f.read, 'jpg')
    end
  end


  def test_flash_object_new
    flash_object = FlashObject.new(JPG_FILE)
  end

  #
  # Testing file type detection and creation by file type
  #
  #

  def test_pdf_create
    begin
      output_file = "#{CURRENT_DIR}/test.swf"
      flash_object = FlashObject.new(PDF_FILE)
      flash_object.jpegquality(80)
      flash_object.save(output_file)

      assert(File.exist?(output_file))
    ensure
      File.delete(output_file)
    end
  end
  def test_pdf_create_with_password
    output_file = "#{CURRENT_DIR}/test_password.swf"
    begin
      flash_object = FlashObject.new(PDF_PASSW_PROTECTED)
      flash_object.jpegquality(80)
      flash_object.password("test")
      flash_object.save(output_file)
      assert(File.exist?(output_file))
    ensure
      File.delete(output_file)
    end
  end

  def test_pdf_create_with_password_without_save_declaration
    output_file = "#{CURRENT_DIR}/test_password.swf"
    begin
    
      flash_object = FlashObject.new(PDF_PASSW_PROTECTED)
      flash_object.jpegquality(80)
      flash_object.password("test")
      flash_object.output(output_file)
      flash_object.save()
      assert(File.exist?(output_file))
      assert_equal output_file, flash_object.output_path      
    ensure
      File.delete(output_file)
    end
  end

  def test_font_create
    output_file = "#{CURRENT_DIR}/arial.swf"
    begin
      flash_object = FlashObject.new(FONT_FILE)
      flash_object.save(output_file)
      assert(File.exist?(output_file))
    ensure
      File.delete(output_file)
    end
  end

  def test_gif_create
    output_file = "#{CURRENT_DIR}/gif.swf"
    begin
      flash_object = FlashObject.new(GIF_FILE)
      flash_object.save(output_file)
      assert(File.exist?(output_file))
    ensure
      File.delete(output_file)
    end
  end

  def test_png_create
    output_file = "#{CURRENT_DIR}/png.swf"
    begin
      flash_object = FlashObject.new(PNG_FILE)
      flash_object.save(output_file)
      assert(File.exist?(output_file))
    ensure
      File.delete(output_file)
    end
  end

  def test_jpg_create
    output_file = "#{CURRENT_DIR}/jpg.swf"
    begin
      flash_object = FlashObject.new(JPG_FILE)
      flash_object.save(output_file)
      assert(File.exist?(output_file))
    ensure
      File.delete(output_file)
    end
  end

  def test_create_from_blob
    output_file = "#{CURRENT_DIR}/jpg_blob.swf"
    begin
      tt = File.open(JPG_FILE, "rb")
      flash_object = FlashObject.from_blob(tt.read, 'jpg')
      flash_object.quality(80)
      flash_object.save(output_file)
      assert(File.exist?(output_file))
      assert_equal output_file, flash_object.output_path

    ensure

      File.delete(output_file)
    end
  end

  def test_create_from_blob_block
    output_file = "#{CURRENT_DIR}/jpg_block.swf"
    begin
    
      tt = File.open(JPG_FILE, "rb")
      flash_object = FlashObject.from_blob(tt.read, 'jpg') do |f|
        f.quality(80)
        f.output(output_file)
        f.save()
      end
      puts output_file
      assert(File.exist?(output_file))
      assert_kind_of Hash, flash_object.info
      assert_equal output_file, flash_object.output_path

    ensure
    
      File.delete(output_file)
    end
  end

  def test_creating_viewer
    output_file = "#{CURRENT_DIR}/jpg.swf"
    output_file = "#{CURRENT_DIR}/test_viewer.swf"
    begin
      flash_object = FlashObject.new(PDF_FILE)
      flash_object.jpegquality(80)
      flash_object.viewer(VIEW_SWF)
      flash_object.save(output_file)
      assert(File.exist?(output_file))
    ensure
      File.delete(output_file)
    end
  end




  #
  # Testing errors and bad types
  #

  def test_file_not_exist
    assert_raise(FlashToolError) { flash_object = FlashObject.new("nofile.jpg")   }
  end

  def test_wrong_file_type
    assert_raise(FlashToolError) {flash_object = FlashObject.new("bad_ext.txt")}
  end


  def test_block
    output_file = "#{CURRENT_DIR}/jpg.swf"
    begin
      flash_object = FlashObject.new(JPG_FILE) do |f|
        f.quality(80)
      end
      flash_object.save(output_file)

      assert(File.exist?(output_file))
    ensure
      File.delete(output_file)
    end
  end

  def test_info
    output_file = "#{CURRENT_DIR}/jpg.swf"
    begin
      flash_object = FlashObject.new(JPG_FILE)
      assert_equal nil, flash_object.info
      flash_object.output(output_file)
      assert_equal nil, flash_object.info
      flash_object.save()
      assert_not_equal nil, flash_object.info

    ensure
      File.delete(output_file)
    end
  end

  def test_without_outputh_path
    begin
      flash_object = FlashObject.new(JPG_FILE)
      flash_object.save()
      assert_equal("#{CURRENT_DIR}test.swf" , flash_object.output_path)
    ensure
      File.delete(flash_object.output_path)
    end
  end


end

