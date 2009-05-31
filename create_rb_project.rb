#!/usr/bin/env ruby

# adapted from: http://blog.jayfields.com/2006/10/ruby-project-tree.html

require 'fileutils'

project_name = ARGV[0]

if project_name == nil
  puts "You must provide a project name."
  puts "Usage: ./create_project.rb project_name"
  exit
end

if test(?d, project_name)
  puts "A directory #{project_name} already exists."
  exit
end

lib = project_name + "/lib"
test = project_name + "/test"
bin = project_name + "/bin"
rakefile = project_name + '/rakefile.rb'
all_tests = test + "/all_tests.rb"
main = lib + "/" + project_name + ".rb"
test_helper = test + "/test_helper.rb"
executable = bin + "/" + project_name

#FileUtils.rm_rf project_name

puts "creating: " + project_name
Dir.mkdir project_name

puts "creating: " + lib
Dir.mkdir lib

puts "creating: " + test
Dir.mkdir test

puts "creating: " + bin
Dir.mkdir bin

puts "creating: " + rakefile
File.open(rakefile, 'w') do |file|
file << <<-eos
task :default => :test

task :test do
require File.dirname(__FILE__) + '/test/all_tests.rb'
end
eos
end

puts "creating: " + executable
File.open(executable, 'w') do |file|
  file << <<-eos
#!/usr/bin/env ruby
$LOAD_PATH.push File.join(File.dirname(__FILE__), "/../lib") 
require '#{project_name}'
eos
  file.chmod(0755)
end

puts "creating: " + all_tests
File.open(all_tests, 'w') do |file|
  file << "Dir['**/*_test.rb'].each { |test_case| require test_case }"
end

puts "creating: " + main
File.open(main, 'w') do |file|
  file << <<-eos
# example
# lib = File.dirname(__FILE__)
# 
# require lib + '/object.rb'
# require lib + '/symbol.rb'
# require lib + '/array.rb'
# require lib + '/string.rb'
# require lib + '/numeric.rb'
# require lib + '/time.rb'
# require lib + '/sql_statement.rb'
# require lib + '/where_builder.rb'
# require lib + '/select.rb'
# require lib + '/insert.rb'
# require lib + '/update.rb'
# require lib + '/delete.rb'
eos
end

puts "creating: " + test_helper
File.open(test_helper, 'w') do |file|
  file << <<-eos
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/#{project_name}'
eos
end