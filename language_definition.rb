class LanguageDefinition

  attr_accessor :language_name
  attr_accessor :comment_symbol
  attr_accessor :multiline_begin_symbol
  attr_accessor :multiline_end_symbol

  # a comment here

  def initialize(language_hash)
    @language_name = language_hash['name']
    @comment_symbol = language_hash['comment']
    @multiline_begin_symbol = language_hash['multilineBegin']
    @multiline_end_symbol = language_hash['multilineEnd']
  end # End initialize()

end # End class
