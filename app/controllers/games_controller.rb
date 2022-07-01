require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @alphabet = ('a'..'z').to_a
    @letters = []
    10.times { @letters << @alphabet[rand(0..25)] }
  end

  def score
    @guess = params["guess"]
    @letters = params["letters"].chars
    @guess_tally = @guess.downcase.chars.tally
    @letters_tally = @letters.tally
    @valid_letters = true
    @guess_tally.each_pair do |letter, value|
      @valid_letters = false if @letters_tally[letter].nil? || value > @letters_tally[letter]
    end
    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    word_serialized = URI.parse(url).open.read
    word_hash = JSON.parse(word_serialized)
    @english = word_hash['found']
    @result = if @valid_letters && @english
                "Congratulations! #{@guess} was indeed an English word you could make :)"
              elsif @english && !@valid_letters
                "Yes, #{@guess} is a nice word... But it's not using the given letters :("
              elsif @valid_letters && !@english
                "I guess #{@guess} does use the given letters... But what does that even mean? :("
              else
                "Bro u wot"
              end
  end
end
