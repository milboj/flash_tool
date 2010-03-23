require 'tempfile'
require File.dirname(__FILE__) + '/flash_tool/flash_script.rb'
require File.dirname(__FILE__) + '/flash_tool/flash_object.rb'
require File.dirname(__FILE__) + '/flash_tool/flash.rb'
require File.dirname(__FILE__) + '/flash_tool/flash_combine.rb'

module FlashTool
  class FlashToolError < RuntimeError
  end

  # This class provides usefull utilities for getting informations from flash files
  # ===<b>Important</b>
  # Method FlashTool.text and options FlashTool.method_missing("text", "file") and
  # swfdump("file","text") on same system don't work appropriate instead use method <b>parse_text</b>
  #
  class FlashTool
    class <<self
      # This method parse text from swf file.
      # File must have extension swf
      def parse_text(file)
        # something is bad with this program don't send errors, and we must check for errors
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



      # Call swfdump commands in shorter way
      # Can be used any option from  swfdump command
      # in casess: width, heihght and frames returns Integer
      # in case rate returns Float
      # in all other casess retruns String
      #
      def method_missing(option, file)
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
      def flash_info(file)
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
      # ===Examples
      #  FlashTool.swfdump('test.swf', 'rate')
      #
      #  FlashTool.swfdump('test.swf', ['rate','width','height'])
      def swfdump(file, option=nil)
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

  end
end


