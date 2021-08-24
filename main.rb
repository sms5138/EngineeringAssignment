require 'fileutils'
require 'etc'
require 'socket'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on('-f', '--filepath PATHTOFILE', 'Source name') { |v| options[:path_to_file] = v }
  opts.on('-T', '--text TEXTTOADD', 'Source host') { |v| options[:text_to_add] = v }
  opts.on('-p', '--sourceport PORT', 'Source port') { |v| options[:source_port] = v }

end.parse!

# p options
# p ARGV
#
# puts "hello #{options[:source_name]}"

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

  entry = "#{Time.now.getutc} | #{method_name} | #{Etc.getlogin} | #{action}"
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
def create_new_file(path_to_file, extension)
  dir = File.dirname(path_to_file)

  unless File.directory?(dir)
    FileUtils.mkdir_p(dir)
  end

  path_to_file << ".#{extension}"
  File.new(path_to_file, 'w')
  create_log_entry("create_new_file", "The following file has been created: #{path_to_file}")
  puts "The following file has been created: #{path_to_file}"
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
def open_application(application_name)
  if File.exist? ("/Applications/#{application_name}.app")
    pid = spawn("open '/Applications/#{application_name}.app' -gj")
    create_log_entry("open_application", "#{application_name} started with pid: #{pid}.")
    puts "#{application_name} started with pid: #{pid}."
  else
    create_log_entry("open_application", "#{application_name} couldn't be located, and couldn't start.")
    puts "#{application_name} couldn't be located, and couldn't start."
  end
end

def open_file(path_to_file)

  # Open the file to show that it has been created, and modified.
  pid = spawn("open #{path_to_file}")

  create_log_entry("open_file", "#{path_to_file} was opened in TextEdit with PID: #{pid}")
  puts "#{path_to_file} was opened in TextEdit with PID: #{pid}"

  # Delay to allow assignment.txt to open before it gets deleted.
  sleep(1)
end
