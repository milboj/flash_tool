# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'flash_tool/version'


Gem::Specification.new do |gem|
  gem.name = "flash_tool"
  gem.version = FlashTool::VERSION
  gem.authors = ["Bojan Milosavljevic "]
  gem.email = ["milboj@gmail.com"]
  gem.description = %q{A ruby wrapper for swftool command line tool. http://www.swftools.org/ 
Flash tool is small and mini tool for creating swf files from pdfs, pictures and
fonts and parsing data from flash files.}

  gem.summary = %q{Simple and mini tool for creating swf (flash) files from pdf, jpg, png and gif with swftools}
  gem.summary = %q{Easy way to detect time zone by address or location }
  gem.homepage = "https://github.com/milboj/flash_tool"
  gem.required_ruby_version = ">= 1.8.7"

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
