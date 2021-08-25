require 'fileutils'
require 'etc'
require 'socket'
require 'optparse'
require 'net/http'
require 'uri'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on('-f', '--filepath PATHTOFILE', 'Path of file to be created, modified, or deleted') { |v| options[:path_to_file] = v }
  opts.on("-c", "--create", "Determines if the file defined in --filepath will be created.") { |v| options[:create] = v }
  opts.on('-t', '--text TEXTTOADD', 'Desired text to be added to the file defined in --filepath') { |v| options[:text_to_add] = v }
  opts.on("-d", "--delete", "Determines if the file defined in --filepath will be deleted.") { |v| options[:delete] = v }
  opts.on('-s', '--script SCRIPTNAME', 'Path to .sh file that is to be executed') { |v| options[:script_path] = v }
  opts.on('-a', '--args SCRIPTARGUMENTS', 'Arguements to be passed to .sh script associated with --script.') { |v| options[:script_args] = v }
  opts.on('-w', '--website HTTPWEBSITE', 'HTTP address for the website that will receive data') { |v| options[:website] = v }
  opts.on('-m', '--message MESSAGETOWEBSITE', 'This is the plain text message that will be sent to the website in question.') { |v| options[:message_to_website] = v }
end.parse!

##### Log related Method
def create_log_entry(method_name, action)
  home_directory = __dir__
  if !(File.exist?("#{home_directory}/EngineeringAssignmentLog.csv"))
    puts "Log file will be located at #{home_directory}/EngineeringAssignmentLog.csv"
    File.new("#{home_directory}/EngineeringAssignmentLog.csv", 'w')



    open("#{home_directory}/EngineeringAssignmentLog.csv", 'a') { |f|
      f.puts "Time,Method,User,ProcessID,Description"
      f.puts "#{Time.now.getutc},create_log_entry,#{Etc.getlogin},#{Process.pid},The log file has been created at: #{home_directory}/EngineeringAssignmentLog.csv"
    }
  end

  entry = "#{Time.now.getutc},#{method_name},#{Etc.getlogin},#{Process.pid},#{action}"
  open("#{home_directory}/EngineeringAssignmentLog.csv", 'a') { |f|
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

def send_data_to_network(url_to_receive_data,message_to_send)
  uri = URI.parse("#{url_to_receive_data}")
  request = Net::HTTP::Post.new(uri)
  request.content_type = "text/plain"
  request["Accept"] = "application/json"
  request.body = "#{message_to_send}"

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  puts "The following message: '#{message_to_send}' was sent to: #{url_to_receive_data} from #{get_ip} and received the following response: #{response}."
  create_log_entry("send_data_to_network", "The following message: '#{message_to_send}' was sent to: #{url_to_receive_data} from #{get_ip} and received the following response: #{response}.")
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
  create_log_entry("modify_file", "'#{text_to_add}' has been added to #{path_to_file}.")
    puts "'#{text_to_add}' has been added to #{path_to_file}."

end


##### Process Related Methods
def open_process(path_to_file)

  pid = spawn("#{path_to_file}")

  create_log_entry("open_file", "#{path_to_file} was opened in TextEdit with PID: #{pid}")
  puts "#{path_to_file} has been started with PID: #{pid}"

end

def open_process_with_args(path_to_file, args_for_script)

    path_to_file << " #{args_for_script}"
    pid = spawn("#{path_to_file}")

    create_log_entry("open_file", "#{path_to_file} was opened in TextEdit with PID: #{pid}")
    puts "#{path_to_file} has been started with PID: #{pid}"

end


##### 
if !(options[:path_to_file].nil?)
  puts "Entering file manipulation section..."
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
  puts "Entering process running section..."
  if options[:script_args].nil?
    puts "Running script with no args..."
    open_process(options[:script_path])
  else
    puts "Running script with args..."
    open_process_with_args(options[:script_path],options[:script_args])
  end
end

if !(options[:website].nil?)
  puts "Entering network connection section..."
  if !(options[:message_to_website].nil?)
    send_data_to_network(options[:website],options[:message_to_website])
  else
    puts "No message was provided to be sent."
  end
end
