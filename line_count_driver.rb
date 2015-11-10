#!/usr/bin/env ruby

require_relative 'file_reader'

class LineCountDriver

  attr_accessor :reader
  attr_reader :code_count
  attr_reader :comment_count

  def initialize()
    # Initialize the required objects
    @reader = FileReader.new
    # Variables to hold the running counts
    @code_count = 0
    @comment_count = 0
    # Read in command line argument to get file name
    file_name = ARGV[0]
    if File.file?(file_name)
      result = run_one_file(file_name)
      @return_value = [result[0].to_s + " comment lines",result[1].to_s() + " code lines"]
    elsif File.directory?(file_name)
      result = run_directory_recursively(file_name)
      @return_value = [result[0].to_s + " comment lines",result[1].to_s() + " code lines"]
    else
      @return_value = "Not a file or directory"
    end # End if File.file?(file_name)
    puts @return_value
  end # End initialize()

  def run_one_file(file_name)
    # Check if is a file
    if File.file?(file_name)
      # Pass the file into the reader and collect the response
      response = @reader.read_file(file_name)
    else
      # Default response
      response = [0,0]
    end
    return response
  end # End run_one_file()

  def run_directory_recursively(directory_name)
    # Check if is a file or a directory
    if File.file?(directory_name)
      # If file, run file
      return run_one_file(directory_name)
    elsif File.directory?(directory_name)
      # Get a list of all files and subdirectories in the directory
      file_names = Dir.entries(directory_name)
      # TODO: Loop through list of files and subdirectories, add_response_to_counts(recursive call) for each
      file_names.each do |file|
        if file != ".." && file != "."
          add_response_to_counts(run_directory_recursively(directory_name + "/" + file))
        end # End if file != ".." && file != "."
      end # End file_names.each do
      # TODO: Return counts
      return [@comment_count, @code_count]
    else
      return [0,0]
    end # End if File.file?()
  end # End run_directory_recursively()

  def add_response_to_counts(response)
    @comment_count += response[0]
    @code_count += response[1]
  end # End add_response_to_counts()

end # End class

if __FILE__ == $0
  driver = LineCountDriver.new()
end
