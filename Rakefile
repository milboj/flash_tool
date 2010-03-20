require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "flash_tool"
    gem.summary = "Simple and mini tool for creating swf (flash) files from pdf, jpg, png and gif with swftools"
    gem.description = "A ruby wrapper for swftool command line tool. http://www.swftools.org/ 
Flash tool is small and mini tool for creating swf files from pdfs, pictures and
fonts and parsing data from flash files."
    gem.email = "milboj@gmail.com"
    gem.homepage = "http://github.com/milboj/flash_tool"
    gem.authors = ["Bojan Milosavljevic"]
    gem.rubyforge_project = 'flash_tool'


#   gem.add_development_dependency "", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "flash_tool #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/*.rb')
end

