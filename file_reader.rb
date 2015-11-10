require 'json'
require_relative 'language_definition'

class FileReader

  attr_reader :language_definition_objects
  attr_reader :extension_language_pairs
  attr_reader :comment_count
  attr_reader :code_count

  def initialize()
    zero_counts()
    # Holds one object for each language supported
    @language_definition_objects = []
    # Has one entry for every file_extension recognized
    # Format is 'file_extension'(key) => '@language_definition_objects index'(value)
    @extension_language_pairs = load_language_extensions()
  end # End initialize()

  def get_file_extension(file_name)
    extension = File.extname(file_name)
    return extension
  end # End get_file_extension()

  def determine_language(extension)
    language = ""
    # Try to find the extension as a key
    language = @extension_language_pairs[extension]
    # If the extension was not found as a key
    if language == nil
      language = "unknown"
    end # End if
    return language
  end # End determine_language

  def load_language_extensions()
    # The hash to be returned
    languages = Hash.new
    if @extension_language_pairs == nil
      # Loop through all of the files in the 'languages' directory
      Dir.foreach("./languages") { |file_name|
        # Exclude Unix control flow "files"
        if file_name != "." && file_name != ".."
          # Create a hash from the contents of the file
          language_hash = JSON.parse(File.read("./languages/" + file_name))
          # Create a LanguageDefinition object
          language_definition_object = LanguageDefinition.new(language_hash)
          # Store into @language_definition_objects
          @language_definition_objects.push(language_definition_object)
          # Get the index of the object just added to the array
          language_index = @language_definition_objects.count-1
          # Loop through each entry with the 'extensions' key in the hash
          language_hash['extensions'].each { |extension|
            # Create an association between the extension and the language definition object's index in @language_definition_objects
            languages.store("." + extension, language_index)
          }
        end # End if file_name != "." && file_name != ".."
      }
    end # End if @extension_language_pairs.length == 0
    return languages
  end # End load_languages()

  def get_language_for_file(file_name)
    zero_counts()
    # Get file extension
    extension = get_file_extension(file_name)
    # Determine language index in @language_definition_objects based on extension
    language_index = determine_language(extension)
    # Get a reference to the relevant language definition object
    language_definition_object = @language_definition_objects[language_index]
    #puts "file_reader.rb: language definition object language name = " + language_definition_object.language_name
    return language_definition_object
  end # End get_language_for_file()

  def zero_counts()
    @comment_count = 0
    @code_count = 0
  end # End zero_counts()

  def scan_file_with_language(file_name, language_definition_object)
    zero_counts()
    # Load the definitions from language_definition_object into memory
    comment_symbol = language_definition_object.comment_symbol
    multiline_begin_symbol = language_definition_object.multiline_begin_symbol
    multiline_end_symbol = language_definition_object.multiline_end_symbol
    # get the length of the comment symbol
    # Boolean to determine if in a multiline comment
    in_multiline = false
    output_array = []
    # Load the file and loop through each line in the file
    File.open(file_name, "r") do |open_file|
      open_file.each_line do |line|
        # Trim leading whitespace
        line = line.lstrip
        # Check if in a multiline comment
        if in_multiline
          if /\S/ !~ line # REGEX for empty lines
            # Do nothing for empty lines
          else
            # Look for the multiline end symbol
            if line.include?(multiline_end_symbol)
              in_multiline = false
            end # End if line.include?(multiline_end_symbol)
            @comment_count += 1
          end # End
        else # if !in_multiline
          # Check if the beginning of the line matches the comment symbol
          if line[0,comment_symbol.length] == comment_symbol
            @comment_count += 1
          # Check if the beginning of the line matches the multiline beginning symbol
          elsif line[0,multiline_begin_symbol.length] == multiline_begin_symbol
            @comment_count += 1
            # Check if there is a multiline end symbol on the same line (in case the multiline starts and ends on the same line)
            if line.include?(multiline_end_symbol)
              # Do nothing, we have entered and exited a multiline in one line
            else # if !line.include?(multiline_end_symbol)
              # Indicate we are in a multiline
              in_multiline = true
            end # End if line.include?(multiline_end_symbol)
          elsif /\S/ !~ line # REGEX for empty lines
            # Do nothing for empty lines
          else # if line[0,common_symbol.length] != comment_symbol && line[0,multiline_begin_symbol.length] != multiline_begin_symbol
            @code_count += 1
          end # End if line[0,common_symbol.length] == comment_symbol
        end # End if in_multiline
      end # End open_file.each_line
    end # End File.open()
    #output_array.push(comment_symbol)
    output_array.push(@comment_count)
    output_array.push(@code_count)
    return output_array
  end # End scan_file_with_language()

  def read_file(file_name)
    extension = get_file_extension(file_name)
    language = determine_language(extension)
    result = scan_file_with_language(file_name, @language_definition_objects[language])
    return result
  end # End read_file()

end # End class
