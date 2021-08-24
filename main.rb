require 'fileutils'
require 'etc'
require 'io/console'

def press_any_key
  print "Please press any key to continue..."
  STDIN.getch
  print "            \r"
end

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
  pid = spawn("open -a TextEdit -W #{path_to_file}")

  create_log_entry("open_file", "#{path_to_file} was opened in TextEdit with PID: #{pid}")
  puts "#{path_to_file} was opened in TextEdit with PID: #{pid}"
  # Delay to allow assignment.txt to open before it gets deleted.
  #sleep(1)
  press_any_key
end

#get home directory
home_directory = File.expand_path('~')

# create a file
create_new_file("#{home_directory}/assignment", "txt")


# modify a file
modify_file("#{home_directory}/assignment.txt", "This is the text that is being added...")

# start process by opening file in TextEdit.
open_file("#{home_directory}/assignment.txt")

# delete a file
delete_file("#{home_directory}/assignment.txt")

# Open an application
#open_application("Google Chrome")
