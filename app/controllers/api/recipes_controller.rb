class Api::RecipesController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    recipes = RecipeSearch.new(params).call.includes(:category, :ingredients)
    render json: recipes.map { |recipe| recipe_json(recipe) }
  end

  def show
    render json: recipe_json(Recipe.includes(:category, :ingredients).find_by!(slug: params[:id]))
  end

  def create
    recipe = Recipe.new(recipe_params)

    if recipe.save
      render json: recipe_json(recipe), status: :created
    else
      render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    recipe = Recipe.find_by!(slug: params[:id])

    if recipe.update(recipe_params)
      render json: recipe_json(recipe)
    else
      render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    Recipe.find_by!(slug: params[:id]).destroy!
    head :no_content
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, :instructions, :cooking_time, :servings, :difficulty, :image_url, :published, :category_id)
  end

  def recipe_json(recipe)
    {
      id: recipe.id,
      title: recipe.title,
      slug: recipe.slug,
      description: recipe.description,
      cooking_time: recipe.cooking_time,
      servings: recipe.servings,
      difficulty: recipe.difficulty_name,
      image_url: recipe.image_url,
      category: recipe.category.name,
      ingredients: recipe.ingredients.map(&:name),
      url: recipe_url(recipe)
    }
  end
end
