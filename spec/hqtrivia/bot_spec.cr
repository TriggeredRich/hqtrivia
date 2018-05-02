require "../../spec_helper"

class MyBot
  include HqTrivia::Bot

  getter words

  def initialize
    @words = {} of String => Int32
  end

  def handle_message(message : HqTrivia::Model::Interaction)
    message.metadata.message.split(/\s/).each do |word|
      @words[word.downcase] ||= 0
      @words[word.downcase] += 1
    end
  end
end

module HqTrivia
  describe Bot do
    it "works" do
      messages = File.read("./spec/data/fullgame").each_line.to_a
      connection = Connection::Local.new(messages)

      bot = MyBot.new
      bot.play(connection)

      bot.words.values.max.should eq(328)
    end
  end
end