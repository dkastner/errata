require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "errata"
    gem.summary = %Q{Correct strings based on remote errata files}
    gem.description = %Q{Correct strings based on remote errata files}
    gem.email = "seamus@abshere.net"
    gem.homepage = "http://github.com/seamusabshere/errata"
    gem.authors = ["Seamus Abshere", "Andy Rossmeissl"]
    %w{ activesupport seamusabshere-remote_table }.each { |name| gem.add_dependency name }
    gem.require_path = "lib"
    gem.files.include %w(lib/erratum) unless gem.files.empty? # seems to fail once it's in the wild
    gem.rdoc_options << '--line-numbers' << '--inline-source'
    # gem.rubyforge_project = "errata"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end




task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "errata #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
