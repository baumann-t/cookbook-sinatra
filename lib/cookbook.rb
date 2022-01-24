require "csv"
require_relative "recipe"

class Cookbook
  attr_accessor :recipes

  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    read_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    store_csv
  end

  def remove_recipe(index)
    @recipes.delete_at(index - 1)
    store_csv
  end

  def update_recipe_done(index)
    @recipes[index].mark_as_done!
    store_csv
  end

  private

  def store_csv
    CSV.open(@csv_file_path, "wb") do |csv|
      @recipes.each do |object|
        csv << [object.name, object.description, object.rating, object.done, object.prep_time]
      end
    end
  end

  def read_csv
    CSV.foreach(@csv_file_path) do |row|
      name = row[0]
      description = row[1]
      rating = row[2]
      done = row[3] == "true"
      prep_time = row[4]
      recipe = Recipe.new(name, description, rating, done, prep_time)
      @recipes << recipe
    end
  end
end
