require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require "puma"
require_relative 'lib/recipe'
require_relative 'lib/cookbook'    # You need to create this file!

cookbook = Cookbook.new('lib/recipes.csv')

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  @recipes = cookbook.recipes
  erb :index
end

get '/new' do
  erb :form
end

post '/recipes' do
  name = params['recipe_name']
  desc = params['description']
  rating = params['rating']
  prep_time = params['prep_time']
  new = Recipe.new(name, desc, false, rating, prep_time)
  cookbook.add_recipe(new)
  redirect to '/'
end

post '/destroy' do
  cookbook.remove_recipe(params['delete'])
end
