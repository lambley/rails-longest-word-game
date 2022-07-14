require 'open-uri'
require 'json'

WAGON_URL = 'https://wagon-dictionary.herokuapp.com/'.freeze

# Game logic for /new and /score pages
class GamesController < ApplicationController
  def new
    # display new random grid and a form
    @letters = (1..10).map { ('a'..'z').to_a[rand(26)] }
    # form will be submitted with POST to the score action
  end

  def score
    # calculate score
    @word = params[:word]
    @grid = params[:grid].split(' ')
    @res = dictionary_lookup(@word)
  end

  private

  def word_in_grid?(attempt, grid_array)
    # compares attempt char array to grid_array char array
    (attempt - grid_array).empty?
  end

  def result_message(result, word)
    result == 'true' ? "#{word} is valid" : "sorry, #{word} is not valid"
  end

  def dictionary_lookup(word)
    @res = JSON.parse(URI.open("#{WAGON_URL}#{word}").read)
    @res['found']
  end
end
