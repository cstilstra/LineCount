require 'rspec'
require_relative '../language_definition'

describe LanguageDefinition do

  # tests for intitialize()
  it "initialize() loads the correct values for all languages" do
    # ruby
    language_hash = JSON.parse(File.read("./languages/ruby.json"))
    definition = LanguageDefinition.new(language_hash)
    expect(definition.comment_symbol).to eq("#")
    expect(definition.multiline_begin_symbol).to eq("=begin")
    expect(definition.multiline_end_symbol).to eq("=end")
    # java
    language_hash = JSON.parse(File.read("./languages/java.json"))
    definition = LanguageDefinition.new(language_hash)
    expect(definition.comment_symbol).to eq("//")
    expect(definition.multiline_begin_symbol).to eq("/*")
    expect(definition.multiline_end_symbol).to eq("*/")
    # c++
    language_hash = JSON.parse(File.read("./languages/c++.json"))
    definition = LanguageDefinition.new(language_hash)
    expect(definition.comment_symbol).to eq("//")
    expect(definition.multiline_begin_symbol).to eq("/*")
    expect(definition.multiline_end_symbol).to eq("*/")
  end

end
