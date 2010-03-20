# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{flash_tool}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["milboj"]
  s.date = %q{2010-03-20}
  s.description = %q{A ruby wrapper for swftool command line tool. http://www.swftools.org/ 
Flash tool is small and mini tool for creating swf files from pdfs, pictures and
fonts and parsing data from flash files.}
  s.email = %q{milboj@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "flash_tool.gemspec",
     "lib/flash_tool.rb",
     "test/25-1.gif",
     "test/bad_ext.txt",
     "test/bad_swf.swf",
     "test/jpeg.swf",
     "test/liberationserif_bold.ttf",
     "test/rfxview.swf",
     "test/test.jpg",
     "test/test.pdf",
     "test/test.png",
     "test/test_flash_data.rb",
     "test/test_flash_tool.rb",
     "test/test_with_password.pdf",
     "test/tester.swf"
  ]
  s.homepage = %q{http://github.com/milboj/flash_tool}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{flash_tool}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Simple and mini tool for creating swf (flash) files from pdf, jpg, png and gif with swftools}
  s.test_files = [
    "test/test_flash_tool.rb",
     "test/test_flash_data.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

