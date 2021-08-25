# EngineeringAssignment
This program will allow the user to do the following:

1. Start a process with or without Arguements
2. Create a file in a desired location based
3. Modify a file based on the provided filepath
4. Delete a file based on the provided filepath
5. Connect to an `http` website and send a message.

# Usage
## Using the script

Open a terminal on macOS or Linux, and navigate to the location of the `main.rb` script.

Call the script using the following syntax `ruby main.rb` with desired combination of options listed below (examples of each scenario will be further explained below)

**Note: A log file will be available that provides a detailed record of the actions preformed in usage of this script. It will be located in the directory where the script is located. The log file will be named: EngineeringAssignmentLog.csv**

```
Usage: example.rb [options]
    -f, --filepath PATHTOFILE        Path of file to be created, modified, or deleted
    -c, --create                     Determines if the file defined in --filepath will be created.
    -t, --text TEXTTOADD             Desired text to be added to the file defined in --filepath
    -d, --delete                     Determines if the file defined in --filepath will be deleted.
    -s, --script SCRIPTNAME          Path to .sh file that is to be executed
    -a, --args SCRIPTARGUMENTS       Arguements to be passed to .sh script associated with --script.
    -w, --website HTTPWEBSITE        HTTP address for the website that will receive data
    -m, --message MESSAGETOWEBSITE   This is the plain text message that will be sent to the website in question.
```

## Creating a new file

**Description**

By defining the filepath with the `-f` option in conjuction with the `-c` option the script will enter file creation mode, and create a new file in the desired location if the file does not already exist. 

**Syntax**
```
EngineeringAssignment % ruby main.rb -f testing.txt -c                             
Entering file manipulation section...
The following file has been created: testing.txt
```

## Modify a file

**Description**

Providing text using the `-t` option in addition to defining the filepath with the `-f` option will enter file modification mode, and will append the provided text entry to the desired file.

**Syntax**
```
EngineeringAssignment % ruby main.rb -f testing.txt -t "Text to be added to file..."
Entering file manipulation section...
'Text to be added to file...' has been added to testing.txt.
```

## Delete a file

**Description**

By defining the filepath with the `-f` option in conjuction with the `-d` option the script will enter file deletion mode, and delete a file in the desired location if the file exist. 

**Syntax**
```
EngineeringAssignment % ruby main.rb -f testing.txt -d                              
Entering file manipulation section...
testing.txt has been deleted.
```

## Start a Process

**Description**

Provide the path to the desired script using the `-s` option, and the script process will start. By adding an addition arugment using the `-a` option the script will run using the arguments provided.

**Syntax without arguments**
```
EngineeringAssignment % ruby main.rb -s ./testScript.sh
Entering process running section...
Running script with no args...
./testScript.sh has been started with PID: 12086
this is the script.
```

**Syntax with arguments**
```
EngineeringAssignment % ruby main.rb -s ./testScript.sh -a "-v"
Entering process running section...
Running script with args...
./testScript.sh -v has been started with PID: 12129
this is the script.
```

## Send data over network

**Description**

By defining the website using the `-w` option with the addition of the `-m`, containing the desired text, will send the message to the desired website, and provide the response from that website.

**Syntax**
```
EngineeringAssignment % ruby main.rb -w "https://www.google.com" -m "hello google."
Entering network connection section...
The following message: 'hello google.' was sent to: https://www.google.com from 192.168.X.X and received the following response: #<Net::HTTPMethodNotAllowed:0x000000010e9a54e8>
```