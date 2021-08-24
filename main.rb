require 'fileutils'
require 'etc'
require 'socket'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on('-f', '--filepath PATHTOFILE', 'Path of file to be created, modified, or deleted') { |v| options[:path_to_file] = v }
  opts.on("-c", "--create", "Determines if the file defined in --filepath will be created.") { |v| options[:create] = v }
  opts.on('-t', '--text TEXTTOADD', 'Desired text to be added to the file defined in --filepath') { |v| options[:text_to_add] = v }
  opts.on("-d", "--delete", "Determines if the file defined in --filepath will be deleted.") { |v| options[:delete] = v }
  opts.on('-s', '--script SCRIPTNAME', 'Path to .sh file that is to be executed') { |v| options[:script_path] = v }
  opts.on('-a', '--args SCRIPTARGUMENTS', 'Arguements to be passed to .sh script associated with --script.') { |v| options[:script_args] = v }

end.parse!

##### Log related Method
def create_log_entry(method_name, action)
  home_directory = File.expand_path('~')
  if !(File.exist?("#{home_directory}/testing.log"))
    puts "Log file will be located at #{home_directory}/testing.log"
    File.new("#{home_directory}/testing.log", 'w')

    open("#{home_directory}/testing.log", 'a') { |f|
      f.puts "#{Time.now.getutc} | create_log_entry | #{Etc.getlogin} | The log file has been created at: #{home_directory}/testing.log"
    }
  end

  entry = "#{Time.now.getutc} | #{method_name} | #{Etc.getlogin} | #{action} | #{Process.pid}"
  open("#{home_directory}/testing.log", 'a') { |f|
    f.puts entry
  }
end

##### Network related Methods
def get_ip
  # turn off reverse DNS resolution temporarily
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true

  UDPSocket.open do |s|
    # connect to google.com
    s.connect '64.233.187.99', 1
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end

##### File Related Methods
def create_new_file(path_to_file)
  dir = File.dirname(path_to_file)

  unless File.directory?(dir)
    FileUtils.mkdir_p(dir)
  end

  if !(File.exist?(path_to_file))
    File.new(path_to_file, 'w')
    create_log_entry("create_new_file", "The following file has been created: #{path_to_file}")
    puts "The following file has been created: #{path_to_file}"
  else
    create_log_entry("create_new_file", "The following file could not be created as it already exists: #{path_to_file}")
    puts "The following file could not be created as it already exists: #{path_to_file}"
  end
end

def delete_file(path_to_file)
  if File.exist?(path_to_file)
    File.delete(path_to_file)
    create_log_entry("delete_file", "#{path_to_file} has been deleted.")
    puts "#{path_to_file} has been deleted."
  end
end

def modify_file(path_to_file, text_to_add)
  open(path_to_file, 'a') { |f|
    f.puts text_to_add
  }
  create_log_entry("modify_file", "Information has been added to #{path_to_file}.")
    puts "Information has been added to #{path_to_file}."

end


##### Process Related Methods
def open_file(path_to_file)

  # Open the file to show that it has been created, and modified.
  
  pid = spawn("#{path_to_file}")

  create_log_entry("open_file", "#{path_to_file} was opened in TextEdit with PID: #{pid}")
  puts "#{path_to_file} has been started with PID: #{pid}"

end


##### 
if !(options[:path_to_file].nil?)
  puts "found"
  if !(options[:create].nil?)
    create_new_file(options[:path_to_file])
  end

  if !(options[:delete].nil?)
    delete_file(options[:path_to_file])
  end

  if !(options[:text_to_add].nil?)
    modify_file(options[:path_to_file], options[:text_to_add])
  end
end

if !(options[:script_path].nil?)
  if options[:script_args].nil?
    puts "run script with no args"
  else
    puts "run script with args."
  end
end
