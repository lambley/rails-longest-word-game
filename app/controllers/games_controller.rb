require 'open-uri'
require 'json'

WAGON_URL = 'https://wagon-dictionary.herokuapp.com/'.freeze

# Game logic for /new and /score pages
class GamesController < ApplicationController
  def new
    # display new random grid and a form => array
    @letters = (1..10).map { ('a'..'z').to_a[rand(26)] }
    # start time to pass to score method => float
    @start_time = Time.now.to_f
    # form will be submitted with POST to the score action => integer
    @high_score = params[:score].to_i > params[:high_score].to_i ? params[:score].to_i : params[:high_score]
  end

  def score
    # submit time, rounded to 2dp => float
    @time_taken = (Time.now.to_f - params[:start_time].to_f).round(2)
    # player's word attempt, downcased => string
    @word = params[:word].downcase
    # that round's letters => array
    @grid = params[:grid].split(' ')
    # check if word exist in dictionary and grid => bool
    @result = exists_in_dictionary?(@word) && word_in_grid?(@word.chars, @grid)
    # message to player based on if the word exists in dictionary and in grid => string
    @result_message = result_message(@result, @word)
    # score value based on time and length => integer
    @score = @result ? calculate_score(@word, @time_taken) : 0
  end

  private

  def word_in_grid?(attempt, grid_array)
    # compares attempt char array to grid_array char array
    (attempt - grid_array).empty?
  end

  def result_message(result, word)
    result ? "Congrats! #{word.capitalize} is a valid word" : "Sorry, #{word} is not valid. Please try again"
  end

  def exists_in_dictionary?(word)
    res = JSON.parse(URI.open("#{WAGON_URL}#{word}").read)
    res['found']
  end

  def calculate_score(word, time)
    base_score = (word.length / time) * 1000
    base_score.round
  end
end
