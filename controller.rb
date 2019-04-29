require_relative "view"
require_relative "recipe"
require_relative 'scrape_french_service'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  # USER ACTIONS

  def list
    display_recipes
  end

  def create
    # 1. Ask user for a name (view)
    name = @view.ask_user_for("name")
    # 2. Ask user for a description (view)
    description = @view.ask_user_for("description")
    # 3. Ask user for a prep_time (view)
    prep_time = @view.ask_user_for("prep_time")
    # 4. Create recipe (model)
    recipe = Recipe.new(name: name, description: description, prep_time: prep_time)
    # 5. Store in cookbook (repo)
    @cookbook.add_recipe(recipe)
    # 6. Display
    display_recipes
  end

  def destroy
    # 1. Display recipes
    display_recipes
    # 2. Ask user for index (view)
    index = @view.ask_user_for_index
    # 3. Remove from cookbook (repo)
    @cookbook.remove_recipe(index)
    # 4. Display
    display_recipes
  end

  def search
    # 1. Ask user for keyword
    keyword = @view.ask_user_for("ingredient")
    # 2. Call scrape french service
    @view.display_to_user("Searching web for recipes with #{keyword}...")
    service = ScrapeFrenchService.new(keyword)
    recipes = service.call

    # 3. Display imported recipes list with index
    @view.display(recipes)

    # 4. Ask user which recipe he wants to import
    index = @view.ask_user_for_index

    # 5. Store the recipe in the repository
    @cookbook.add_recipe(recipes[index])
  end

  def mark_as_done
    display_recipes
    # Ask user for index
    index = @view.ask_user_for_index
    # Set the selected recipe to done
    @cookbook.mark_as_done(index)
  end

  private

  def display_recipes
    # 1. Get recipes (repo)
    recipes = @cookbook.all
    # 2. Display recipes in the terminal (view)
    @view.display(recipes)
  end
end
